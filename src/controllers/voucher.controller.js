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

// GET ONE BY ID
exports.getVoucherById = async (req, res) => {
    try {
        const voucher = await Voucher.getById(req.params.id);
        if (!voucher) {
            return res.status(404).json({ success: false, message: 'Voucher not found' });
        }
        res.status(200).json({ success: true, data: voucher });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// CREATE
exports.createVoucher = async (req, res) => {
    try {
        // Validate cơ bản
        if (!req.body.code || !req.body.discount_value) {
            return res.status(400).json({ success: false, message: 'Missing required fields' });
        }

        const newId = await Voucher.create(req.body);
        res.status(201).json({
            success: true,
            message: 'Voucher created successfully',
            voucherId: newId
        });
    } catch (error) {
        // Bắt lỗi trùng mã code (Duplicate entry)
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
        if (affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Voucher not found or no changes made' });
        }
        res.status(200).json({ success: true, message: 'Voucher updated successfully' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// DELETE
exports.deleteVoucher = async (req, res) => {
    try {
        const affectedRows = await Voucher.delete(req.params.id);
        if (affectedRows === 0) {
            return res.status(404).json({ success: false, message: 'Voucher not found' });
        }
        res.status(200).json({ success: true, message: 'Voucher deleted successfully' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

// CHECK / APPLY VOUCHER (Dùng cho Mobile App lúc Checkout)
exports.applyVoucher = async (req, res) => {
    try {
        const { code, orderTotal } = req.body;
        const voucher = await Voucher.getByCode(code);

        if (!voucher) {
            return res.status(404).json({ success: false, message: 'Mã giảm giá không tồn tại' });
        }

        // Kiểm tra ngày hết hạn
        const now = new Date();
        if (now < new Date(voucher.start_date) || now > new Date(voucher.end_date)) {
            return res.status(400).json({ success: false, message: 'Mã giảm giá đã hết hạn' });
        }

        // Kiểm tra số lượng
        if (voucher.usage_limit > 0 && voucher.used_count >= voucher.usage_limit) {
            return res.status(400).json({ success: false, message: 'Mã giảm giá đã hết lượt sử dụng' });
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        if (orderTotal < voucher.min_order_value) {
            return res.status(400).json({
                success: false,
                message: `Đơn hàng phải tối thiểu ${voucher.min_order_value} để sử dụng mã này`
            });
        }

        // Tính toán số tiền được giảm
        let discountAmount = 0;
        if (voucher.discount_type === 'fixed') {
            discountAmount = voucher.discount_value;
        } else {
            // Tính theo %
            discountAmount = (orderTotal * voucher.discount_value) / 100;
            // Nếu có set giới hạn giảm tối đa (ví dụ giảm 10% nhưng tối đa 50k)
            if (voucher.max_discount_amount && discountAmount > voucher.max_discount_amount) {
                discountAmount = voucher.max_discount_amount;
            }
        }

        res.status(200).json({
            success: true,
            message: 'Áp dụng mã thành công',
            data: {
                code: voucher.code,
                discount_amount: parseFloat(discountAmount),
                final_total: orderTotal - discountAmount
            }
        });

    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};