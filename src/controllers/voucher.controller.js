const Voucher = require('../models/voucher.model');

// GET ALL
exports.getAllVouchers = async (req, res) => {
    try {
        const vouchers = await Voucher.getAll();
        res.status(200).json({ success: true, data: vouchers });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// GET ONE
exports.getVoucherById = async (req, res) => {
    try {
        const voucher = await Voucher.getById(req.params.id);
        if (!voucher) return res.status(404).json({ success: false, message: 'Voucher not found' });
        res.status(200).json({ success: true, data: voucher });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// CREATE
exports.createVoucher = async (req, res) => {
    try {
        const { code, discount_value } = req.body;
        if (!code || !discount_value) {
            return res.status(400).json({ success: false, message: 'Missing required fields' });
        }

        const newId = await Voucher.create(req.body);
        res.status(201).json({ success: true, message: 'Voucher created', voucherId: newId });
    } catch (error) {
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ success: false, message: 'Voucher code already exists' });
        }
        res.status(500).json({ success: false, message: error.message });
    }
};

// UPDATE
exports.updateVoucher = async (req, res) => {
    try {
        const affectedRows = await Voucher.update(req.params.id, req.body);
        if (affectedRows === 0) return res.status(404).json({ success: false, message: 'Voucher not found or no change' });
        res.status(200).json({ success: true, message: 'Voucher updated' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// DELETE
exports.deleteVoucher = async (req, res) => {
    try {
        const affectedRows = await Voucher.delete(req.params.id);
        if (affectedRows === 0) return res.status(404).json({ success: false, message: 'Voucher not found' });
        res.status(200).json({ success: true, message: 'Voucher deleted' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// APPLY VOUCHER
exports.applyVoucher = async (req, res) => {
    try {
        const { code, orderTotal } = req.body;

        if (!code) {
            return res.status(400).json({ success: false, message: 'Missing voucher code' });
        }

        if (orderTotal === undefined || orderTotal === null) {
            return res.status(400).json({ success: false, message: 'Missing order total' });
        }

        // Chuyển orderTotal sang number
        const orderTotalNum = parseFloat(orderTotal);
        if (isNaN(orderTotalNum)) {
            return res.status(400).json({ success: false, message: 'Invalid order total' });
        }

        const voucher = await Voucher.getByCode(code);
        if (!voucher) {
            return res.status(404).json({ success: false, message: 'Voucher không hợp lệ hoặc đã hết hạn' });
        }

        // Chuyển discount_value và min_order_amount sang number
        const discountValue = parseFloat(voucher.discount_value);
        const minOrderAmount = parseFloat(voucher.min_order_amount);

        if (orderTotalNum < minOrderAmount) {
            return res.status(400).json({
                success: false,
                message: `Đơn hàng phải tối thiểu ${minOrderAmount} để sử dụng voucher`
            });
        }

        // Tính giảm giá
        let discountAmount = 0;
        if (voucher.discount_type === 'fixed') {
            discountAmount = discountValue;
        } else {
            discountAmount = (orderTotalNum * discountValue) / 100;

            // Nếu có max_discount_amount, áp dụng giới hạn
            if (voucher.max_discount_amount) {
                const maxDiscount = parseFloat(voucher.max_discount_amount);
                if (discountAmount > maxDiscount) discountAmount = maxDiscount;
            }
        }

        // Cập nhật used_count
        await Voucher.incrementUsedCount(voucher.id);

        res.status(200).json({
            success: true,
            message: 'Voucher áp dụng thành công',
            data: {
                code: voucher.code,
                discount_amount: parseFloat(discountAmount.toFixed(2)),
                final_total: parseFloat((orderTotalNum - discountAmount).toFixed(2))
            }
        });

    } catch (error) {
        console.error('applyVoucher error:', error);
        res.status(500).json({ success: false, message: error.message });
    }
};
