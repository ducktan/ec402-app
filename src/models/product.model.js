const pool = require("../config/db");

class Product {
  // ====== CREATE PRODUCT ======
  static async create({ seller_id, category_id, name, description, price, stock }) {
    const [result] = await pool.query(
      `INSERT INTO products (seller_id, category_id, name, description, price, stock) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [seller_id, category_id, name, description, price, stock]
    );
    return { id: result.insertId, seller_id, category_id, name, description, price, stock };
  }

  // ====== GET ALL PRODUCTS ======
  static async findAll({ category_id }) {
    let sql = `SELECT * FROM products`;
    const params = [];
    if (category_id) {
      sql += ` WHERE category_id = ?`;
      params.push(category_id);
    }
    const [rows] = await pool.query(sql, params);
    return rows;
  }

  // ====== GET PRODUCT BY ID ======
  static async findById(id) {
    const [rows] = await pool.query(`SELECT * FROM products WHERE id = ?`, [id]);
    return rows[0];
  }

  // ====== UPDATE PRODUCT (chỉ cập nhật field có trong body) ======
  static async updateProduct(id, fields) {
    const keys = Object.keys(fields);
    if (keys.length === 0) return null;

    const updates = keys.map(key => `${key} = ?`).join(", ");
    const values = keys.map(key => fields[key]);
    values.push(id);

    await pool.query(`UPDATE products SET ${updates} WHERE id = ?`, values);
    return this.findById(id);
  }

  // ====== DELETE PRODUCT ======
  static async deleteProduct(id) {
    await pool.query(`DELETE FROM products WHERE id = ?`, [id]);
    return true;
  }
}

module.exports = Product;
