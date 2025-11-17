const express = require("express");
const router = express.Router();
const userController = require("../controllers/user.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const UserAddress = require("../models/userAddress.model");
const { uploadAvatar } = require("../controllers/user.controller");
const upload = require("../middlewares/upload");

// cập nhật user
router.put("/", authMiddleware, userController.updateUser);

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




