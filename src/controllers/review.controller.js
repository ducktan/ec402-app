const db = require('../config/db');

// Lấy danh sách review theo product_id
exports.getReviewsByProduct = async (req, res) => {
    try {
        const { productId } = req.params;
        
        // Join bảng reviews với bảng users để lấy tên và avatar người đánh giá
        const sql = `
            SELECT r.*, u.name as user_name, u.avatar as user_avatar
            FROM reviews r
            JOIN users u ON r.user_id = u.id
            WHERE r.product_id = ?
            ORDER BY r.created_at DESC
        `;
        
        const [reviews] = await db.query(sql, [productId]);
        
        // Tính toán thống kê (Option)
        // ... (Có thể thêm logic tính trung bình sao ở đây nếu cần)

        res.status(200).json({ success: true, data: reviews });
    } catch (error) {
        console.error("Lỗi lấy review:", error);
        res.status(500).json({ message: "Lỗi Server" });
    }
};

// Thêm review mới (Dành cho user đã mua hàng - Tạm thời làm đơn giản)
exports.createReview = async (req, res) => {
    try {
        const { product_id, rating, comment } = req.body;
        const user_id = req.user.id; // Lấy từ middleware auth

        const sql = `INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)`;
        await db.query(sql, [product_id, user_id, rating, comment]);

        res.status(201).json({ success: true, message: "Đánh giá thành công" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};