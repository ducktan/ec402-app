const pool = require("../config/db");

const Wishlist = {
  /**
   * Thêm sản phẩm vào wishlist
   * (INSERT IGNORE để tránh trùng user_id + product_id)
   */
  async add(userId, productId) {
    const [result] = await pool.query(
      "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)",
      [userId, productId]
    );
    return result.insertId; // = 0 nếu đã tồn tại
  },

  /**
   * Xóa sản phẩm khỏi wishlist
   */
  async remove(userId, productId) {
    const [result] = await pool.query(
      "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?",
      [userId, productId]
    );
    return result.affectedRows > 0;
  },

  /**
   * Lấy danh sách wishlist của user
   */
  async findByUser(userId) {
    const [rows] = await pool.query(
      `SELECT
         p.id,
         p.name,
         p.price,
         p.description,
         p.brand_id,
         p.category_id,
         p.stock,
         w.created_at
       FROM products p
       JOIN wishlist w ON p.id = w.product_id
       WHERE w.user_id = ?
       ORDER BY w.created_at DESC`,
      [userId]
    );
    return rows;
  },
};

module.exports = Wishlist;
