const User = require("../models/user.model");
const UserAddress = require("../models/userAddress.model");

// Cập nhật thông tin user
exports.updateUser = async (req, res) => {
  try {
    const userId = req.user.id; // lấy từ middleware auth
    const { name, phone, avatar } = req.body;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    await User.updateUser(userId, { name, phone, avatar });

    res.json({ message: "User updated successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
};


// GET /api/users/profile
exports.getUserProfile = async (req, res) => {
  try {
    const userId = req.user.userId; // lấy từ token middleware

    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // không trả password_hash
    const { password_hash, ...userData } = user;

    res.json(userData);
  } catch (err) {
    console.error("Get profile error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

// address controllers can be added here
// --- CRUD địa chỉ ---

// 1️⃣ Thêm địa chỉ mới
exports.createAddress = async (req, res) => {
  try {
    const userId = req.user.id;
    const id = await UserAddress.create(userId, req.body);
    res.status(201).json({ message: "Thêm địa chỉ thành công", id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// 2️⃣ Lấy tất cả địa chỉ
exports.getAddresses = async (req, res) => {
  try {
    const userId = req.user.id;
    const addresses = await UserAddress.findByUserId(userId);
    res.json(addresses);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// 3️⃣ Lấy địa chỉ cụ thể
exports.getAddressById = async (req, res) => {
  try {
    const userId = req.user.id;
    const address = await UserAddress.findById(req.params.id, userId);
    if (!address) return res.status(404).json({ message: "Không tìm thấy địa chỉ" });
    res.json(address);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// 4️⃣ Cập nhật địa chỉ
exports.updateAddress = async (req, res) => {
  try {
    const userId = req.user.id;
    await UserAddress.update(req.params.id, userId, req.body);
    res.json({ message: "Cập nhật địa chỉ thành công" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// 5️⃣ Xóa địa chỉ
exports.deleteAddress = async (req, res) => {
  try {
    const userId = req.user.id;
    await UserAddress.delete(req.params.id, userId);
    res.json({ message: "Xóa địa chỉ thành công" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

