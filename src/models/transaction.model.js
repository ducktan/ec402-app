const pool = require("../config/db");

class Transaction {
  // =============================
  // CREATE TRANSACTION
  // =============================
  static async create({ order_id, user_id, provider, amount, status, transaction_code }) {
    const [result] = await pool.query(
      `INSERT INTO transactions (order_id, user_id, provider, amount, status, transaction_code)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [order_id, user_id, provider, amount, status, transaction_code || ""]
    );

    return {
      id: result.insertId,
      order_id,
      user_id,
      provider,
      amount,
      status,
      transaction_code: transaction_code || "",
    };
  }

  // =============================
  // ADMIN FUNCTIONS
  // =============================
  static async adminGetAll() {
    const [rows] = await pool.query(
      `SELECT t.id, t.order_id, t.user_id, t.provider, t.amount, t.status, t.transaction_code, t.created_at,
              u.name AS user_name
       FROM transactions t
       JOIN users u ON u.id = t.user_id
       ORDER BY t.id DESC`
    );
    return rows;
  }
}

module.exports = Transaction;
