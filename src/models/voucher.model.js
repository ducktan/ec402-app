const db = require('../config/db'); 

class Voucher {
    // 1. Lấy tất cả Voucher
    static async getAll() {
        const [rows] = await db.query('SELECT * FROM vouchers ORDER BY created_at DESC');
        return rows;
    }

    // 2. Lấy Voucher theo ID
    static async getById(id) {
        const [rows] = await db.query('SELECT * FROM vouchers WHERE id = ?', [id]);
        return rows[0];
    }

    // 3. Lấy Voucher theo Code (Để user apply)
    static async getByCode(code) {
        const [rows] = await db.query('SELECT * FROM vouchers WHERE code = ? AND status = "active"', [code]);
        return rows[0];
    }

    // 4. Tạo Voucher mới
    static async create(data) {
        const {
            code, discount_type, discount_value, min_order_value,
            max_discount_amount, start_date, end_date, usage_limit
        } = data;

        const sql = `
            INSERT INTO vouchers 
            (code, discount_type, discount_value, min_order_value, max_discount_amount, start_date, end_date, usage_limit) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `;

        const [result] = await db.query(sql, [
            code, discount_type, discount_value, min_order_value || 0,
            max_discount_amount || null, start_date, end_date, usage_limit || 0
        ]);
        return result.insertId;
    }

    // 5. Cập nhật Voucher
    static async update(id, data) {
        const {
            code, discount_type, discount_value, min_order_value,
            max_discount_amount, start_date, end_date, usage_limit, status
        } = data;

        const sql = `
            UPDATE vouchers 
            SET code=?, discount_type=?, discount_value=?, min_order_value=?, 
                max_discount_amount=?, start_date=?, end_date=?, usage_limit=?, status=?
            WHERE id=?
        `;

        const [result] = await db.query(sql, [
            code, discount_type, discount_value, min_order_value,
            max_discount_amount, start_date, end_date, usage_limit, status, id
        ]);
        return result.affectedRows;
    }

    // 6. Xóa Voucher
    static async delete(id) {
        const [result] = await db.query('DELETE FROM vouchers WHERE id = ?', [id]);
        return result.affectedRows;
    }
}

module.exports = Voucher;