const pool = require("../config/db");

class UserAddress {
  // Thêm địa chỉ mới
  static async create(userId, data) {
    const sql = `
      INSERT INTO user_addresses (user_id, street, ward, district, city, country, postal_code)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `;
    const [result] = await pool.query(sql, [
      userId,
      data.street,
      data.ward,
      data.district,
      data.city,
      data.country,
      data.postal_code,
    ]);
    return result.insertId;
  }

  // Lấy tất cả địa chỉ theo user
  static async findByUserId(userId) {
    const [rows] = await pool.query("SELECT * FROM user_addresses WHERE user_id = ?", [userId]);
    return rows;
  }

  // Lấy địa chỉ cụ thể
  static async findById(id, userId) {
    const [rows] = await pool.query("SELECT * FROM user_addresses WHERE id = ? AND user_id = ?", [id, userId]);
    return rows[0];
  }

  // Cập nhật
  static async update(id, userId, data) {
    const fields = [];
    const values = [];

    ["street", "ward", "district", "city", "country", "postal_code"].forEach((key) => {
      if (data[key] !== undefined) {
        fields.push(`${key} = ?`);
        values.push(data[key]);
      }
    });

    if (fields.length === 0) return;

    const sql = `UPDATE user_addresses SET ${fields.join(", ")} WHERE id = ? AND user_id = ?`;
    values.push(id, userId);
    await pool.query(sql, values);
  }

  // Xóa
  static async delete(id, userId) {
    await pool.query("DELETE FROM user_addresses WHERE id = ? AND user_id = ?", [id, userId]);
  }
}

module.exports = UserAddress;
