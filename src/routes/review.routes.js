const express = require("express");
const router = express.Router();
const reviewCtrl = require("../controllers/review.controller");
const { authMiddleware } = require("../middlewares/auth.middleware"); // xác thực user

// 1. Lấy tất cả review
router.get("/", reviewCtrl.getAllReviews);

// 2. Lấy review theo reviewId
router.get("/:id", reviewCtrl.getReviewById);

// 3. Lấy review theo productId
router.get("/product/:productId", reviewCtrl.getReviewsByProduct);

// 4. Thêm review (login required)
router.post("/", authMiddleware, reviewCtrl.addReview);

// 5. Sửa review (login required)
router.put("/:id", authMiddleware, reviewCtrl.updateReview);

// 6. Xóa review (login required)
router.delete("/:id", authMiddleware, reviewCtrl.deleteReview);

module.exports = router;
