const pool = require('../config/db'); // pool kết nối MySQL

class Review {
  // CREATE
  static async create({ product_id, user_id, rating, comment }) {
    const [result] = await pool.execute(
      `INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)`,
      [product_id, user_id, rating, comment ?? null]
    );

    return {
      id: result.insertId,
      product_id,
      user_id,
      rating,
      comment,
    };
  }

  // READ: Lấy tất cả review của 1 product
   static async findAllByProduct(productId = null) {
        let query = `
        SELECT r.*, u.name AS user_name, u.avatar AS user_avatar 
        FROM reviews r 
        JOIN users u ON r.user_id = u.id
        `;
        let params = [];

        if (productId !== null) {
        query += ` WHERE r.product_id = ?`;
        params.push(productId);
        }

        query += ` ORDER BY r.created_at DESC`;

        const [rows] = await pool.execute(query, params);

        const count = rows.length;
        const avgRating = count > 0 ? (rows.reduce((sum, r) => sum + r.rating, 0) / count).toFixed(1) : 0;

        return { count, avgRating, reviews: rows };
    }

  // READ: Lấy review theo ID
  static async findById(id) {
    const [rows] = await pool.execute(
      `SELECT * FROM reviews WHERE id = ?`,
      [id]
    );
    return rows[0];
  }

  // UPDATE
  static async update(id, fields) {
    const keys = Object.keys(fields).filter(k => fields[k] !== undefined);
    if (keys.length === 0) return false;

    const setClause = keys.map(k => `${k} = ?`).join(", ");
    const values = keys.map(k => fields[k]);
    values.push(id);

    const [result] = await pool.execute(
      `UPDATE reviews SET ${setClause} WHERE id = ?`,
      values
    );
    return result.affectedRows > 0;
  }

  // DELETE
  static async delete(id) {
    const [result] = await pool.execute(
      `DELETE FROM reviews WHERE id = ?`,
      [id]
    );
    return result.affectedRows > 0;
  }
}

module.exports = Review;
