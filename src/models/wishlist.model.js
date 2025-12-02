const pool = require("../config/db");

const Wishlist = {
  async add(userId, productId) {
    const [result] = await pool.query(
      "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)",
      [userId, productId]
    );
    return result.insertId;
  },

  async remove(userId, productId) {
    const [result] = await pool.query(
      "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?",
      [userId, productId]
    );
    return result.affectedRows > 0;
  },

  async findByUser(userId) {
    const [rows] = await pool.query(
      `SELECT
            p.id,
            p.name,
            p.price,
            p.description,
            b.name AS brand_name,
            p.category_id,
            p.stock,
            p.image_url,
            w.created_at
        FROM products p
        JOIN wishlist w ON p.id = w.product_id
        JOIN brands b ON p.brand_id = b.id
        WHERE w.user_id = ?
        ORDER BY w.created_at DESC;`,
      [userId]
    );
    return rows;
  },

  // ✅ Hàm mới: lấy tất cả wishlist (admin)
  async findAll() {
    const [rows] = await pool.query(
      `SELECT
         w.id,
         w.user_id,
         w.product_id,
         w.created_at,
         p.name AS product_name,
         p.price AS product_price
       FROM wishlist w
       JOIN products p ON w.product_id = p.id
       ORDER BY w.created_at DESC`
    );
    return rows;
  },
};

module.exports = Wishlist;
