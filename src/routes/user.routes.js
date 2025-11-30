const express = require("express");
const router = express.Router();
const userController = require("../controllers/user.controller");
const { authMiddleware, isAdmin } = require("../middlewares/auth.middleware");
const upload = require("../middlewares/upload");
const { uploadAvatar } = require("../controllers/user.controller");

// 👥 Lấy tất cả users (public - không cần đăng nhập)
router.get("/public/all", userController.getAllUsersPublic);

// 👥 Lấy tất cả users (chỉ admin)
router.get("/all", userController.getAllUsers);

// 👤 Tạo người dùng mới (chỉ admin)
router.post("/", userController.createUser);

// 👤 Xóa người dùng (không cần auth)
router.delete("/:id", userController.deleteUser);

// Thêm route test không cần auth
router.get("/test", (req, res) => {
  console.log("Test endpoint được gọi");
  res.json({ message: "Kết nối API thành công!" });
});
// Cập nhật user (không cần auth)
router.put("/:id", userController.updateUser);

// get user profile
router.get("/", authMiddleware, userController.getUserProfile);


// --- Address CRUD ---
router.post("/addresses", authMiddleware, userController.createAddress);
router.get("/addresses", authMiddleware, userController.getAddresses);
router.get("/addresses/:id", authMiddleware, userController.getAddressById);
router.put("/addresses/:id", authMiddleware, userController.updateAddress);
router.delete("/addresses/:id", authMiddleware, userController.deleteAddress);
router.post("/upload-avatar", authMiddleware, upload.single("avatar"), uploadAvatar);


module.exports = router;




