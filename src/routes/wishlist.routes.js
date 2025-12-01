const express = require("express");
const router = express.Router();
const wishlistController = require("../controllers/wishlist.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

// Bắt buộc đăng nhập
router.use(authMiddleware);

// --- Admin mới xem toàn bộ ---
router.get("/", authorizeRole(["admin"]), wishlistController.getAllWishlist);

// --- User xem wishlist của chính mình ---
router.get("/my", wishlistController.getMyWishlist);

// --- Thêm sản phẩm vào wishlist ---
router.post("/", wishlistController.addToWishlist);

// --- Xóa sản phẩm khỏi wishlist (chỉ của chính mình) ---
router.delete("/:productId", wishlistController.removeFromWishlist);

module.exports = router;
