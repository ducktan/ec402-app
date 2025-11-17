const pool = require("../config/db");

class Cart {
  static async getOrCreateCart(userId) {
    const [rows] = await pool.query("SELECT * FROM carts WHERE user_id = ?", [userId]);
    if (rows.length > 0) return rows[0];
    const [result] = await pool.query("INSERT INTO carts (user_id) VALUES (?)", [userId]);
    return { id: result.insertId, user_id: userId };
  }

  static async getCartWithItems(userId) {
    const [carts] = await pool.query("SELECT * FROM carts WHERE user_id = ?", [userId]);
    if (carts.length === 0) return { cart: null, items: [] };
    const cart = carts[0];
    const [items] = await pool.query(
      `SELECT ci.id, ci.product_id, ci.quantity, p.name, p.price, p.stock, p.brand_id, p.category_id
       FROM cart_items ci
       JOIN products p ON p.id = ci.product_id
       WHERE ci.cart_id = ?`,
      [cart.id]
    );
    return { cart, items };
  }

  static async addItem(userId, productId, quantity) {
    const cart = await this.getOrCreateCart(userId);
    const [existing] = await pool.query(
      "SELECT * FROM cart_items WHERE cart_id = ? AND product_id = ?",
      [cart.id, productId]
    );
    if (existing.length > 0) {
      const newQty = existing[0].quantity + quantity;
      await pool.query("UPDATE cart_items SET quantity = ? WHERE id = ?", [newQty, existing[0].id]);
      return { id: existing[0].id, product_id: productId, quantity: newQty };
    }
    const [result] = await pool.query(
      "INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, ?)",
      [cart.id, productId, quantity]
    );
    return { id: result.insertId, product_id: productId, quantity };
  }

  static async updateItemQuantity(userId, productId, quantity) {
    const cart = await this.getOrCreateCart(userId);
    const [rows] = await pool.query(
      "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ?",
      [quantity, cart.id, productId]
    );
    return rows.affectedRows > 0;
  }

  static async removeItem(userId, productId) {
    const cart = await this.getOrCreateCart(userId);
    const [rows] = await pool.query(
      "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?",
      [cart.id, productId]
    );
    return rows.affectedRows > 0;
  }

  static async clearCart(userId) {
    const cart = await this.getOrCreateCart(userId);
    await pool.query("DELETE FROM cart_items WHERE cart_id = ?", [cart.id]);
    return true;
  }
}

module.exports = Cart;
