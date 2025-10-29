const pool = require("../config/db");

const User = {
  // Tạo user mới
  async createUser({ role, name, email, passwordHash, phone, avatar }) {
    const [result] = await pool.query(
      "INSERT INTO users (role, name, email, password_hash, phone, avatar) VALUES (?, ?, ?, ?, ?, ?)",
      [role || "buyer", name, email, passwordHash, phone || null, avatar || null]
    );
    return result.insertId;
  },

  // Tìm user theo email
  async findUserByEmail(email) {
    const [rows] = await pool.query("SELECT * FROM users WHERE email = ?", [email]);
    return rows[0]; // chỉ trả về 1 user
  },

  // Tìm user theo id
  async findById(id) {
    const [rows] = await pool.query("SELECT * FROM users WHERE id = ?", [id]);
    return rows[0];
  },

  // Cập nhật user
  async updateUser(id, data) {
    const fields = [];
    const values = [];

    if (data.name !== undefined) {
      fields.push("name = ?");
      values.push(data.name);
    }
    if (data.phone !== undefined) {
      fields.push("phone = ?");
      values.push(data.phone);
    }
    if (data.avatar !== undefined) {
      fields.push("avatar = ?");
      values.push(data.avatar);
    }

    if (fields.length === 0) return; // không có gì để update

    const sql = `UPDATE users SET ${fields.join(", ")} WHERE id = ?`;
    values.push(id);

    await pool.query(sql, values);
  },
};

module.exports = User;
