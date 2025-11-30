const pool = require("../config/db");

const User = {
  // 👥 Lấy tất cả users
  async getAllUsers() {
    const [rows] = await pool.query("SELECT * FROM users ORDER BY created_at DESC");
    return rows;
  },
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
    if (data.role !== undefined) {
      fields.push("role = ?");
      values.push(data.role);
    }

    if (fields.length === 0) return; // không có gì để update

    const sql = `UPDATE users SET ${fields.join(", ")} WHERE id = ?`;
    values.push(id);

    await pool.query(sql, values);
  },

  // 🗑️ Xóa user
  async deleteUser(id) {
    await pool.query("DELETE FROM users WHERE id = ?", [id]);
    return true;
  },

  // 🔍 Tìm user theo email (alias cho findUserByEmail để nhất quán)
  async findByEmail(email) {
    return this.findUserByEmail(email);
  }
};

module.exports = User;
