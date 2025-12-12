const pool = require("../config/db");

class NotificationModel {
  
  static async create(user_id, title, message) {
    const [result] = await pool.execute(
      `INSERT INTO notifications (user_id, title, message) VALUES (?, ?, ?)`,
      [user_id, title, message]
    );
    return result.insertId;
  }

  static async getByUser(user_id) {
    const [rows] = await pool.execute(
      `SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC`,
      [user_id]
    );
    return rows;
  }

  static async markAsRead(id) {
    await pool.execute(
      `UPDATE notifications SET is_read = 1 WHERE id = ?`,
      [id]
    );
  }
}

module.exports = NotificationModel;
