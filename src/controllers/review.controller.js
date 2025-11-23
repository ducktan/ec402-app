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

// API: Kiểm tra xem user có được phép đánh giá sản phẩm này không
// GET /api/reviews/check-permission/:productId
exports.checkReviewPermission = async (req, res) => {
    try {
        const { productId } = req.params;
        const userId = req.user.id; // Lấy từ token

        // Query: Tìm đơn hàng của user có chứa sản phẩm này và trạng thái là 'delivered'
        const sql = `
            SELECT o.id 
            FROM orders o
            JOIN order_items oi ON o.id = oi.order_id
            WHERE o.user_id = ? 
            AND oi.product_id = ? 
            AND o.order_status = 'delivered'
            LIMIT 1
        `;

        const [rows] = await db.query(sql, [userId, productId]);

        if (rows.length > 0) {
            // Đã mua và đã nhận hàng -> Được phép đánh giá
            return res.status(200).json({ canReview: true });
        } else {
            return res.status(200).json({ canReview: false, message: "Bạn chưa mua sản phẩm này hoặc đơn hàng chưa được giao thành công." });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Lỗi server" });
    }
};

// API: Tạo đánh giá mới (Cập nhật logic kiểm tra)
// POST /api/reviews
exports.createReview = async (req, res) => {
    try {
        const { product_id, rating, comment } = req.body;
        const user_id = req.user.id;

        // 1. Kiểm tra lại lần nữa xem có được phép đánh giá không (Double check server-side)
        const checkSql = `
            SELECT o.id 
            FROM orders o
            JOIN order_items oi ON o.id = oi.order_id
            WHERE o.user_id = ? AND oi.product_id = ? AND o.order_status = 'delivered'
            LIMIT 1
        `;
        const [orders] = await db.query(checkSql, [user_id, product_id]);

        if (orders.length === 0) {
            return res.status(403).json({ message: "Bạn chỉ được đánh giá sau khi đã nhận hàng thành công!" });
        }

        // 2. Kiểm tra xem đã đánh giá chưa (Mỗi sản phẩm chỉ được đánh giá 1 lần)
        const [existing] = await db.query("SELECT id FROM reviews WHERE user_id = ? AND product_id = ?", [user_id, product_id]);
        if (existing.length > 0) {
            return res.status(400).json({ message: "Bạn đã đánh giá sản phẩm này rồi." });
        }

        // 3. Insert review
        const insertSql = `INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)`;
        await db.query(insertSql, [product_id, user_id, rating, comment]);

        res.status(201).json({ success: true, message: "Cảm ơn bạn đã đánh giá!" });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};