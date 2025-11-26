const db = require('../config/db');

class Voucher {
    // Lấy tất cả voucher (Admin/Seller)
    static async getAll() {
        const [rows] = await db.query('SELECT * FROM vouchers ORDER BY created_at DESC');
        return rows;
    }

    // Lấy voucher theo ID
    static async getById(id) {
        const [rows] = await db.query('SELECT * FROM vouchers WHERE id = ?', [id]);
        return rows[0];
    }

    // Lấy voucher theo code (dùng cho người dùng)
    static async getByCode(code) {
        const [rows] = await db.query(
            `SELECT * FROM vouchers 
             WHERE code = ? 
               AND status = 'active' 
               AND (expires_at IS NULL OR expires_at > NOW())
               AND start_at <= NOW()
               AND (usage_limit IS NULL OR used_count < usage_limit)
            `,
            [code]
        );
        return rows[0];
    }

    // Tạo voucher mới
    static async create(data) {
        const {
            code, description, discount_type, discount_value,
            min_order_amount, usage_limit, start_at, expires_at, status
        } = data;

        const sql = `
            INSERT INTO vouchers
            (code, description, discount_type, discount_value, min_order_amount, usage_limit, start_at, expires_at, status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;

        const [result] = await db.query(sql, [
            code, description || null, discount_type, discount_value,
            min_order_amount || 0, usage_limit || null, start_at || null, expires_at || null, status || 'active'
        ]);

        return result.insertId;
    }

    // Cập nhật voucher
    static async update(id, data) {
        const allowedFields = [
            'code','description','discount_type','discount_value',
            'min_order_amount','usage_limit','start_at','expires_at','status'
        ];

        const fields = [];
        const values = [];

        for (const key of allowedFields) {
            if (data[key] !== undefined) {
                fields.push(`${key} = ?`);
                values.push(data[key]);
            }
        }

        if (fields.length === 0) return 0; // Không có trường nào để update

        const sql = `UPDATE vouchers SET ${fields.join(', ')} WHERE id = ?`;
        values.push(id);

        // SỬ DỤNG BIẾN db ĐÃ IMPORT
        const [result] = await db.query(sql, values);
        return result.affectedRows;
    }

    // Xóa voucher
    static async delete(id) {
        const [result] = await db.query('DELETE FROM vouchers WHERE id = ?', [id]);
        return result.affectedRows;
    }

    // Tăng used_count khi voucher được áp dụng
    static async incrementUsedCount(id) {
        const [result] = await db.query(
            'UPDATE vouchers SET used_count = used_count + 1 WHERE id = ? AND (usage_limit IS NULL OR used_count < usage_limit)',
            [id]
        );
        return result.affectedRows;
    }
}

module.exports = Voucher;
