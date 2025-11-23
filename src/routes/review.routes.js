const express = require('express');
const router = express.Router();
const reviewController = require('../controllers/review.controller');
// const { verifyToken } = require('../middlewares/auth.middleware');

// Lấy review của sản phẩm (Public)
router.get('/:productId', reviewController.getReviewsByProduct);

// Viết review (Cần đăng nhập - tạm thời comment verifyToken để test dễ)
// router.post('/', verifyToken, reviewController.createReview);

module.exports = router;