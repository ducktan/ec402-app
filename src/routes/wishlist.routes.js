const express = require("express");
const router = express.Router();
const wishlistController = require("../controllers/wishlist.controller");
const { authMiddleware } = require("../middlewares/auth.middleware"); //

// === BẮT BUỘC ĐĂNG NHẬP CHO TẤT CẢ ROUTE BÊN DƯỚI ===
// Mọi API của wishlist đều cần biết "bạn là ai"
router.use(authMiddleware);

// (GET) Lấy tất cả sản phẩm trong wishlist
// API: GET /api/wishlist/
router.get("/", wishlistController.getWishlist);

// (POST) Thêm 1 sản phẩm vào wishlist
// API: POST /api/wishlist/
// (Gửi kèm body: { "productId": 123 })
router.post("/", wishlistController.addToWishlist);

// (DELETE) Xóa 1 sản phẩm khỏi wishlist
// API: DELETE /api/wishlist/123
router.delete("/:productId", wishlistController.removeFromWishlist);

module.exports = router;