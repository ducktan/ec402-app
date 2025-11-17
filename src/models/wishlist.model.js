const pool = require("../config/db");

const Wishlist = {
  /**
   * Thêm sản phẩm vào wishlist của user
   * (Sẽ tự động bỏ qua nếu đã tồn tại, nhờ CSDL)
   * @param {number} userId
   * @param {number} productId
   */
  async add(userId, productId) {
    const [result] = await pool.query(
      "INSERT IGNORE INTO user_wishlist (user_id, product_id) VALUES (?, ?)",
      [userId, productId]
    );
    // result.insertId sẽ = 0 nếu nó bị IGNORE (bỏ qua)
    return result.insertId;
  },

  /**
   * Xóa sản phẩm khỏi wishlist của user
   * @param {number} userId
   * @param {number} productId
   */
  async remove(userId, productId) {
    const [result] = await pool.query(
      "DELETE FROM user_wishlist WHERE user_id = ? AND product_id = ?",
      [userId, productId]
    );
    // Trả về true nếu xóa thành công (xóa được 1 dòng)
    return result.affectedRows > 0;
  },

  /**
   * Lấy tất cả sản phẩm trong wishlist của 1 user
   * (Chúng ta JOIgit add src/models/wishlist.model.jsN với bảng 'products' để lấy đầy đủ thông tin sản phẩm)
   * @param {number} userId
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
         p.stock
         -- (Thêm bất kỳ cột nào của product bạn muốn hiển thị ở đây)
       FROM products p
       JOIN user_wishlist w ON p.id = w.product_id
       WHERE w.user_id = ?
       ORDER BY w.created_at DESC`, // Sắp xếp theo cái mới nhất
      [userId]
    );
    return rows;
  },
};

module.exports = Wishlist;