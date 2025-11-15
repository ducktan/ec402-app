
const pool = require("../config/db");

class ProductImages {
  // ====== CREATE PRODUCT IMAGE ======
  static async create({ product_id, image_url }) {
    const [result] = await pool.query(
      "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)",
      [product_id, image_url]
    );
    return {
      id: result.insertId,
      product_id,
      image_url,
    };
  }

  // ====== GET ALL PRODUCT IMAGES ======
  static async findAll() {
    const [rows] = await pool.query("SELECT * FROM product_images");
    return rows;
  }

  // ====== GET PRODUCT IMAGE BY ID ======
  static async findById(id) {
    const [rows] = await pool.query(
      "SELECT * FROM product_images WHERE id = ?",
      [id]
    );
    return rows[0];
  }

  // ====== UPDATE PRODUCT IMAGE ======
  static async updateProductImages(id, fields) {
    const keys = Object.keys(fields);
    if (keys.length === 0) return null;

    const updates = keys.map((key) => `${key} = ?`).join(", ");
    const values = keys.map((key) => fields[key]);
    values.push(id);

    await pool.query(
      `UPDATE product_images SET ${updates} WHERE id = ?`,
      values
    );

    return this.findById(id);
  }

  // ====== DELETE PRODUCT IMAGE ======
  static async deleteProductImages(id) {
    await pool.query("DELETE FROM product_images WHERE id = ?", [id]);
    return true;
  }
}

module.exports = ProductImages;
