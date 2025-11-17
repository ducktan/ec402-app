const pool = require("../config/db");

class Product {
  // ====== CREATE PRODUCT ======
  static async create({ brand_id, category_id, name, description, price, stock }) {
    const [result] = await pool.query(
      `INSERT INTO products (brand_id, category_id, name, description, price, stock)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [brand_id, category_id, name, description, price, stock]
    );

    return {
      id: result.insertId,
      brand_id,
      category_id,
      name,
      description,
      price,
      stock,
    };
  }

  // ====== GET ALL PRODUCTS ======
  static async findAll() {
    const [rows] = await pool.query(`SELECT * FROM products`);
    return rows;
  }

  // ====== GET PRODUCT BY ID ======
  static async findById(id) {
    const [rows] = await pool.query(`SELECT * FROM products WHERE id = ?`, [id]);
    return rows[0];
  }

  // ====== GET PRODUCT IMAGES BY PRODUCT ID ======
  static async findImgByProductId(productId) {
    const [rows] = await pool.query(
      `SELECT * FROM product_images WHERE product_id = ?`,
      [productId]
    );
    return rows;
  }


  // ====== UPDATE PRODUCT (động) ======
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
