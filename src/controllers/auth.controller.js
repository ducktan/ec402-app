const User = require("../models/user.model");
const { hashPassword, comparePassword, generateToken } = require("../utils/token");

const db = require("../config/db");
const jwt = require("jsonwebtoken");
const { generateOTP, sendOTP } = require("../utils/token");
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const bcrypt = require('bcryptjs');

// Đăng ký (Register)
exports.register = async (req, res) => {
  try {
    // 1. Lấy dữ liệu từ Postman gửi lên
    const { name, email, password, phone, role } = req.body;

    // 2. Kiểm tra xem đã điền đủ thông tin chưa
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Vui lòng nhập tên, email và mật khẩu!' });
    }

    // 3. Kiểm tra email đã tồn tại chưa
    const [existingUser] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
      return res.status(400).json({ message: 'Email này đã được sử dụng!' });
    }

    // 4. Mã hóa mật khẩu (Quan trọng: DB của bạn lưu password_hash)
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    // 5. Chèn vào Database
    // Lưu ý: Nếu không gửi role, mặc định sẽ là 'buyer' (cần sửa DB như hướng dẫn trước hoặc truyền role từ body)
    const insertQuery = `
            INSERT INTO users (name, email, password_hash, phone, role) 
            VALUES (?, ?, ?, ?, ?)
        `;

    // Nếu role rỗng, gán mặc định là 'buyer' để tránh lỗi DB
    const userRole = role || 'buyer';

    await db.query(insertQuery, [name, email, passwordHash, phone, userRole]);

    return res.status(201).json({ message: 'Đăng ký thành công!' });

  } catch (error) {
    // 🔴 In lỗi chi tiết ra Terminal để debug
    console.error("Lỗi Đăng Ký:", error);
    return res.status(500).json({
      message: 'Lỗi Server',
      error: error.message // Trả về lỗi chi tiết cho Postman xem luôn
    });
  }
};

// Đăng nhập (Login)
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // 1. Tìm user theo email
    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (users.length === 0) {
      return res.status(404).json({ message: 'Email không tồn tại!' });
    }

    const user = users[0];

    // 2. So sánh mật khẩu
    // Lưu ý: DB của bạn cột tên là password_hash
    const isMatch = await bcrypt.compare(password, user.password_hash);
    if (!isMatch) {
      return res.status(400).json({ message: 'Sai mật khẩu!' });
    }

    // 3. Tạo Token
    const token = jwt.sign(
      { id: user.id, role: user.role, email: user.email },
      process.env.JWT_SECRET || 'EC402_APP_KEY',
      { expiresIn: '7d' }
    );

    return res.json({
      message: 'Đăng nhập thành công',
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        avatar: user.avatar
      }
    });

  } catch (error) {
    console.error("Lỗi Đăng Nhập:", error);
    return res.status(500).json({ message: 'Lỗi Server', error: error.message });
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

exports.loginWithGoogle = async (req, res) => {
  try {
    const { idToken } = req.body;
    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const { email, name, picture, sub } = payload;

    // check user
    let user = await User.findOne({ email });
    if (!user) {
      user = await User.create({
        name,
        email,
        googleId: sub,
        avatar: picture,
        password: null, // no password needed
      });
    }

    // create JWT
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });

    return res.json({
      message: 'Google login success',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        role: user.role || 'user',
      },
    });
  } catch (err) {
    console.error(err);
    res.status(400).json({ message: 'Invalid Google token' });
  }
};