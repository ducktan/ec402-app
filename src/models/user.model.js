const pool = require("../config/db");

const User = {
  // 🧩 Tạo user mới
  async createUser({ role, name, email, passwordHash, phone, avatar, gender, dob }) {
    const [result] = await pool.query(
      `INSERT INTO users (role, name, email, password_hash, phone, avatar, gender, dob)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        role || "buyer",
        name,
        email,
        passwordHash,
        phone || null,
        avatar || null,
        gender || "other",
        dob || null, // yyyy-mm-dd format
      ]
    );
    return result.insertId;
  },

  // 🔍 Tìm user theo email
  async findUserByEmail(email) {
    const [rows] = await pool.query("SELECT * FROM users WHERE email = ?", [email]);
    return rows[0];
  },

  // 🔍 Tìm user theo id
  async findById(id) {
    const [rows] = await pool.query("SELECT * FROM users WHERE id = ?", [id]);
    return rows[0];
  },

  // ✏️ Cập nhật user
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
    if (data.gender !== undefined) {
      fields.push("gender = ?");
      values.push(data.gender);
    }
    if (data.dob !== undefined) {
      fields.push("dob = ?");
      values.push(data.dob);
    }

    if (fields.length === 0) return; // không có gì để update

    const sql = `UPDATE users SET ${fields.join(", ")} WHERE id = ?`;
    values.push(id);

    await pool.query(sql, values);
  },
  // Lấy tất cả user
  async getAll() {
    const [rows] = await pool.query("SELECT * FROM users ORDER BY created_at DESC");
    return rows;
  },

  // Xoá user
  async deleteUser(id) {
    await pool.query("DELETE FROM users WHERE id = ?", [id]);
  },

};


module.exports = User;
