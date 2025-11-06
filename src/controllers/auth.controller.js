const User = require("../models/user.model");
const { hashPassword, comparePassword, generateToken } = require("../utils/token");

const db = require("../config/db");
const jwt = require("jsonwebtoken");
const { generateOTP, sendOTP } = require("../utils/token");

// Đăng ký
exports.register = async (req, res) => {
  try {
    const { name, email, password, phone } = req.body;

    // Check email đã tồn tại chưa
    const existingUser = await User.findUserByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: "Email already exists" });
    }

    // Hash password
    const passwordHash = await hashPassword(password);

    // Lưu user vào DB
    const userId = await User.createUser({
      role: "buyer",
      name,
      email,
      passwordHash,
      phone,
    });

    res.status(201).json({ message: "User registered successfully", userId });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// Đăng nhập
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Tìm user theo email
    const user = await User.findUserByEmail(email);
    if (!user) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    // Kiểm tra password
    const isMatch = await comparePassword(password, user.password_hash);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    // Tạo token (dùng utils/token.js)
    const token = generateToken({ id: user.id, role: user.role });

    res.json({
      message: "Login successful",
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};

// 🔹 Gửi OTP
exports.loginWithOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    if (!phone) return res.status(400).json({ message: "Vui lòng nhập số điện thoại" });

    // kiểm tra user tồn tại
    const [user] = await db.query("SELECT * FROM users WHERE phone = ?", [phone]);
    if (user.length === 0) return res.status(404).json({ message: "Không tìm thấy người dùng" });

    // tạo OTP
    const otpCode = generateOTP();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 phút

    await db.query(
      "INSERT INTO otps (user_id, otp_code, expires_at) VALUES (?, ?, ?)",
      [user[0].id, otpCode, expiresAt]
    );

    // gửi OTP (ở đây tạm log)
    await sendOTP(phone, otpCode);

    res.status(200).json({ message: "Đã gửi OTP, vui lòng kiểm tra điện thoại" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// 🔹 Xác minh OTP
exports.verifyOtp = async (req, res) => {
  console.log(req.body);
  try {
    const { phone, otp } = req.body;

    // 1️⃣ Tìm user theo số điện thoại
    const [userRows] = await db.query("SELECT * FROM users WHERE phone = ?", [phone]);
    if (userRows.length === 0)
      return res.status(404).json({ message: "Không tìm thấy người dùng" });

    const user = userRows[0];

    // 2️⃣ Kiểm tra OTP hợp lệ
    const [otpRecord] = await db.query(
      "SELECT * FROM otps WHERE user_id = ? AND otp_code = ? AND is_used = FALSE ORDER BY created_at DESC LIMIT 1",
      [user.id, otp]
    );

    if (otpRecord.length === 0)
      return res.status(400).json({ message: "OTP không hợp lệ" });

    const now = new Date();
    if (now > otpRecord[0].expires_at)
      return res.status(400).json({ message: "OTP đã hết hạn" });

    // 3️⃣ Đánh dấu OTP đã sử dụng
    await db.query("UPDATE otps SET is_used = TRUE WHERE id = ?", [otpRecord[0].id]);

     // Tạo token (dùng utils/token.js)
    const token = generateToken({ id: user.id, role: user.role });

    // 5️⃣ Trả về token kèm thông tin user
    res.status(200).json({
      message: "Xác thực thành công",
      token,
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        avatar: user.avatar,
        role: user.role,
      },
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

exports.logout = async (req, res) => {
  try {
    // Lấy token từ header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "No token provided" });
    }

    const token = authHeader.split(" ")[1];
    const userId = req.user.id; // lấy từ middleware verifyToken

    // Lưu token vào blacklist
    await db.query("INSERT INTO token_blacklist (token, user_id) VALUES (?, ?)", [token, userId]);

    res.status(200).json({ message: "Logout successful" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};