const express = require('express');
const router = express.Router();
const voucherController = require('../controllers/voucher.controller');
// 👇 Import verifyToken từ file middleware hiện có của bạn
const { verifyToken } = require('../middlewares/auth.middleware');

// ==========================================
// Helper: Hàm kiểm tra quyền (Authorize)
// (Do file auth.middleware.js của bạn chưa có hàm này nên mình viết tạm ở đây)
// ==========================================
const authorize = (...allowedRoles) => {
    return (req, res, next) => {
        // req.user đã được gán từ hàm verifyToken
        // Cấu trúc req.user thường là { id: ..., role: 'admin', ... }
        if (!req.user) {
            return res.status(401).json({ success: false, message: 'Unauthorized: User info not found' });
        }

        // Kiểm tra role (role user trong DB của bạn là: 'buyer', 'seller', 'admin')
        // Lưu ý: Đảm bảo trong payload của JWT token có trường 'role'
        if (!allowedRoles.includes(req.user.role)) {
            return res.status(403).json({
                success: false,
                message: `Bạn không có quyền thực hiện hành động này! Yêu cầu quyền: ${allowedRoles.join(', ')}`
            });
        }
        next();
    };
};

// ==========================================
// 1. ROUTES CHO NGƯỜI DÙNG (PUBLIC/BUYER)
// ==========================================

// Áp dụng mã giảm giá khi thanh toán (Cần đăng nhập để check blacklist token và xác định user)
router.post('/apply', verifyToken, voucherController.applyVoucher);


// ==========================================
// 2. ROUTES CHO ADMIN & SELLER (Cần quyền quản trị)
// ==========================================

// Xem danh sách voucher
router.get('/', verifyToken, authorize('admin', 'seller'), voucherController.getAllVouchers);

// Xem chi tiết 1 voucher theo ID
router.get('/:id', verifyToken, authorize('admin', 'seller'), voucherController.getVoucherById);

// Tạo voucher mới
router.post('/', verifyToken, authorize('admin', 'seller'), voucherController.createVoucher);

// Cập nhật voucher
router.put('/:id', verifyToken, authorize('admin', 'seller'), voucherController.updateVoucher);

// Xóa voucher: Chỉ cho Admin xóa (Seller không được xóa)
router.delete('/:id', verifyToken, authorize('admin'), voucherController.deleteVoucher);

module.exports = router;