const User = require("../models/user.model");
const UserAddress = require("../models/userAddress.model");
const { authMiddleware } = require("../middlewares/auth.middleware");
const path = require("path");
const pool = require("../config/db");
const bcrypt = require("bcrypt");

// Cập nhật thông tin user
exports.updateUser = async (req, res) => {
  try {
    const { name, email, phone, role } = req.body;
    const userId = req.params.id; // Lấy ID từ URL parameters

    // Tìm user
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "Không tìm thấy người dùng" });
    }

    // Tạo object chứa các trường cần update (chỉ thêm khi có giá trị)
    const updateData = {};
    if (name) updateData.name = name;
    if (email) updateData.email = email;
    if (phone) updateData.phone = phone;
    if (role) updateData.role = role;

    // Nếu không có gì để update thì báo lại
    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({ message: "No fields to update" });
    }

    // Thực hiện cập nhật
    await User.updateUser(userId, updateData);

    // Lấy lại user mới sau update
    const updatedUser = await User.findById(userId);

    res.status(200).json({
      message: "Cập nhật thông tin người dùng thành công",
      user: {
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
        phone: updatedUser.phone,
        role: updatedUser.role,
        created_at: updatedUser.created_at,
        updated_at: updatedUser.updated_at,
      },
    });
  } catch (err) {
    console.error("Lỗi khi cập nhật người dùng:", err);
    res.status(500).json({ message: "Lỗi server khi cập nhật người dùng" });
  }
};




// GET /api/users/profile
exports.getUserProfile = async (req, res) => {
  try {

    const userId = req.user.id; // lấy từ token middleware
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

// 👥 Lấy tất cả users (public - không cần đăng nhập)
exports.getAllUsersPublic = async (req, res) => {
  try {
    const users = await User.getAllUsers();
    res.status(200).json(users);
  } catch (err) {
    console.error('Lỗi khi lấy danh sách người dùng (public):', err);
    res.status(500).json({ message: 'Lỗi server khi lấy danh sách người dùng' });
  }
};

// 👤 Tạo người dùng mới (chỉ admin)
exports.createUser = async (req, res) => {
  try {
    const { name, email, password, phone, role = 'buyer' } = req.body;

    // Kiểm tra email đã tồn tại chưa
    const existingUser = await User.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: 'Email đã được sử dụng bởi tài khoản khác' });
    }

    // Mã hóa mật khẩu
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Tạo người dùng mới
    const newUser = await User.createUser({
      name,
      email,
      passwordHash: hashedPassword,  // Fixed parameter name to match model
      phone,
      role
    });

    // Không trả về mật khẩu
    const { password_hash, ...userData } = newUser;

    res.status(201).json({
      message: 'Tạo người dùng thành công',
      user: userData
    });
  } catch (err) {
    console.error('Lỗi khi tạo người dùng:', err);
    res.status(500).json({ message: 'Lỗi server khi tạo người dùng' });
  }
};

// 👤 Xóa người dùng
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Kiểm tra xem người dùng có tồn tại không
    const user = await User.findById(id);
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

    // Xóa người dùng
    await User.deleteUser(id);

    res.status(200).json({ message: 'Xóa người dùng thành công' });
  } catch (err) {
    console.error('Lỗi khi xóa người dùng:', err);
    res.status(500).json({ message: 'Lỗi server khi xóa người dùng' });
  }
};

// 👥 Lấy tất cả users (chỉ admin)
exports.getAllUsers = async (req, res) => {
  try {
    // Chỉ admin mới được lấy danh sách users
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Không có quyền truy cập' });
    }

    const users = await User.getAllUsers();
    res.status(200).json(users);
  } catch (err) {
    console.error('Lỗi khi lấy danh sách người dùng:', err);
    res.status(500).json({ message: 'Lỗi server khi lấy danh sách người dùng' });
  }
};

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




exports.uploadAvatar = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "Không có file nào được tải lên" });
    }

    const userId = req.user.id; // lấy từ middleware auth
    const fullUrl = `${req.protocol}://${req.get("host")}`; // vd: http://localhost:5000
    const avatarUrl = `${fullUrl}/uploads/avatars/${req.file.filename}`;

    // Cập nhật vào DB với full đường dẫn
    await pool.query(`UPDATE users SET avatar = ? WHERE id = ?`, [avatarUrl, userId]);

    return res.json({
      message: "Upload thành công",
      avatar_url: avatarUrl,
    });
  } catch (err) {
    console.error("Upload error:", err);
    res.status(500).json({ message: "Lỗi server khi upload avatar" });
  }
};
