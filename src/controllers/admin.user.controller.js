const bcrypt = require("bcryptjs");
const User = require("../models/user.model");

// =========================
// LẤY DANH SÁCH NGƯỜI DÙNG
// =========================
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.getAll();   // <-- Dùng model
    res.json({ success: true, data: users });
  } catch (error) {
    console.error("Error getAllUsers:", error);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
};

// =========================
// THÊM NGƯỜI DÙNG
// =========================
exports.createUser = async (req, res) => {
  try {
    const { role, name, email, password, phone, avatar, gender, dob } = req.body;

    if (!email || !password || !name) {
      return res.status(400).json({ success: false, message: "Thiếu thông tin bắt buộc" });
    }

    // check email trùng
    const exists = await User.findUserByEmail(email);
    if (exists) {
      return res.status(400).json({ success: false, message: "Email đã tồn tại" });
    }

    const passwordHash = await bcrypt.hash(password, 10);

    const userId = await User.createUser({
      role,
      name,
      email,
      passwordHash,
      phone,
      avatar,
      gender,
      dob
    });

    const newUser = await User.findById(userId);

    res.json({
      success: true,
      message: "Tạo người dùng thành công",
      data: newUser
    });
  } catch (error) {
    console.error("Error createUser:", error);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
};

// =========================
// SỬA NGƯỜI DÙNG
// =========================
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;

    const current = await User.findById(id);
    if (!current) {
      return res.status(404).json({ success: false, message: "Không tìm thấy user" });
    }

    let passwordHash = current.password_hash;

    if (req.body.password) {
      passwordHash = await bcrypt.hash(req.body.password, 10);
    }

    // Gọi model update
    await User.updateUser(id, {
      name: req.body.name,
      phone: req.body.phone,
      avatar: req.body.avatar,
      gender: req.body.gender,
      dob: req.body.dob,
      role: req.body.role,
      email: req.body.email,
      password_hash: passwordHash
    });

    const updated = await User.findById(id);

    res.json({ success: true, message: "Cập nhật thành công", data: updated });
  } catch (error) {
    console.error("Error updateUser:", error);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
};

// =========================
// XOÁ NGƯỜI DÙNG
// =========================
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ success: false, message: "User không tồn tại" });
    }

    await User.deleteUser(id);

    res.json({ success: true, message: "Xoá người dùng thành công" });
  } catch (error) {
    console.error("Error deleteUser:", error);
    res.status(500).json({ success: false, message: "Lỗi server" });
  }
};
