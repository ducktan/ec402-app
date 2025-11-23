const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/review.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

// Lấy review (Public)
router.get('/:productId', reviewController.getReviewsByProduct);

// Kiểm tra quyền đánh giá (Cần login)
router.get('/check-permission/:productId', verifyToken, reviewController.checkReviewPermission);

// Tạo review (Cần login)
router.post('/', verifyToken, reviewController.createReview);

module.exports = router;