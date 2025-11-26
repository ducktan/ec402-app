const express = require('express');
const router = express.Router();
const voucherController = require('../controllers/voucher.controller');
const { verifyToken } = require('../middlewares/auth.middleware');

const authorize = (...allowedRoles) => (req, res, next) => {
    if (!req.user) return res.status(401).json({ success: false, message: 'Unauthorized' });
    if (!allowedRoles.includes(req.user.role)) {
        return res.status(403).json({ success: false, message: `Bạn không có quyền. Yêu cầu: ${allowedRoles.join(', ')}` });
    }
    next();
};

// USER
router.post('/apply', verifyToken, voucherController.applyVoucher);

// ADMIN/SELLER
router.get('/', verifyToken, authorize('admin', 'seller'), voucherController.getAllVouchers);
router.get('/:id', verifyToken, authorize('admin', 'seller'), voucherController.getVoucherById);
router.post('/', verifyToken, authorize('admin', 'seller'), voucherController.createVoucher);
router.put('/:id', verifyToken, authorize('admin', 'seller'), voucherController.updateVoucher);
router.delete('/:id', verifyToken, authorize('admin'), voucherController.deleteVoucher);

module.exports = router;
