const pool = require("../config/db");

class Order {
  // =============================
  // CREATE ORDER
  // =============================
  static async create({ user_id, total_amount, payment_method, shipping_address }) {
    const [result] = await pool.query(
      `INSERT INTO orders (user_id, total_amount, payment_method, shipping_address)
       VALUES (?, ?, ?, ?)`,
      [user_id, total_amount, payment_method, JSON.stringify(shipping_address)]
    );

    return {
      id: result.insertId,
      user_id,
      total_amount,
      payment_method,
      shipping_address,
    };
  }

  // CREATE ORDER ITEM
  static async createItem(order_id, product) {
    const [result] = await pool.query(
      `INSERT INTO order_items (order_id, product_id, name, price, quantity)
       VALUES (?, ?, ?, ?, ?)`,
      [
        order_id,
        product.product_id,
        product.name,
        product.price,
        product.quantity,
      ]
    );

    return {
      id: result.insertId,
      ...product,
      order_id,
    };
  }

  // =============================
  // USER FUNCTIONS
  // =============================

  // Lấy danh sách đơn của user
  static async getMyOrders(user_id) {
    const [rows] = await pool.query(
      `SELECT id, total_amount, order_status, created_at
       FROM orders
       WHERE user_id = ?
       ORDER BY id DESC`,
      [user_id]
    );
    return rows;
  }

  // Lấy chi tiết đơn theo ID
  static async getById(order_id) {
    const [rows] = await pool.query(`SELECT * FROM orders WHERE id = ?`, [
      order_id,
    ]);
    return rows[0];
  }

  // Lấy items của 1 đơn
  static async getItems(order_id) {
    const [rows] = await pool.query(
      `SELECT 
        oi.product_id,
        oi.quantity,
        oi.price,
        p.name AS name,
        p.image_url
      FROM order_items oi
      JOIN products p ON oi.product_id = p.id
      WHERE oi.order_id = ?;`,
      [order_id]
    );
    return rows;
  }

  // Người dùng hủy đơn
  static async cancel(order_id) {
    const [result] = await pool.query(
      `UPDATE orders
       SET order_status = 'cancelled'
       WHERE id = ? AND order_status = 'pending'`,
      [order_id]
    );

    return result.affectedRows > 0;
  }

  // =============================
  // ADMIN FUNCTIONS
  // =============================

  // Admin lấy tất cả orders
  static async adminGetAll() {
    const [rows] = await pool.query(
      `SELECT o.id, o.total_amount, o.order_status, o.created_at,
              u.name AS user_name
       FROM orders o
       JOIN users u ON u.id = o.user_id
       ORDER BY o.id DESC`
    );
    return rows;
  }

  // Admin cập nhật trạng thái
  static async adminUpdateStatus(order_id, status) {
    const [result] = await pool.query(
      `UPDATE orders SET order_status = ? WHERE id = ?`,
      [status, order_id]
    );

    return result.affectedRows > 0;
  }
}

module.exports = Order;
