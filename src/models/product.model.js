const pool = require("../config/db");

class Product {
  // ====== CREATE PRODUCT ======
  static async create({ brand_id, category_id, name, description, price, stock, image_url }) {
    const [result] = await pool.query(
      `INSERT INTO products (brand_id, category_id, name, description, price, stock, image_url)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [brand_id, category_id, name, description, price, stock, image_url || null]
    );

    return {
      id: result.insertId,
      brand_id,
      category_id,
      name,
      description,
      price,
      stock,
      image_url: image_url || null,
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


  // GET products theo brand_id
  static async findByBrandId(brandId) {
    const [rows] = await pool.execute(
      'SELECT * FROM products WHERE brand_id = ?',
      [brandId]
    );
    return rows; // trả về array
  }

  // GET products theo category_id
  static async findByCategoryId(categoryId) {
    const [rows] = await pool.execute(
      'SELECT * FROM products WHERE category_id = ?',
      [categoryId]
    );
    return rows; // trả về array
  }

  // ====== SEARCH PRODUCTS (lọc + sắp xếp) ======
  static async search({ query, minPrice, maxPrice, categoryId, sort }) {
    let sql = `
    SELECT p.*, 
    (SELECT image_url FROM product_images WHERE product_id = p.id LIMIT 1) AS image
    FROM products p
    WHERE 1 = 1
  `;

    let params = [];

    // Tìm theo tên hoặc mô tả
    if (query) {
      sql += ` AND (p.name LIKE ? OR p.description LIKE ?)`;
      params.push(`%${query}%`, `%${query}%`);
    }

    if (minPrice) {
      sql += ` AND p.price >= ?`;
      params.push(minPrice);
    }

    if (maxPrice) {
      sql += ` AND p.price <= ?`;
      params.push(maxPrice);
    }

    if (categoryId) {
      sql += ` AND p.category_id = ?`;
      params.push(categoryId);
    }

    // Sắp xếp
    switch (sort) {
      case "price_asc":
        sql += " ORDER BY p.price ASC";
        break;
      case "price_desc":
        sql += " ORDER BY p.price DESC";
        break;
      case "newest":
        sql += " ORDER BY p.created_at DESC";
        break;
      case "rating":
        sql += " ORDER BY p.rating_avg DESC";
        break;
      case "name":
        sql += " ORDER BY p.name ASC"; // sắp xếp theo tên
        break;
      default:
        sql += " ORDER BY p.id DESC";
    }

    const [rows] = await pool.query(sql, params);
    return rows;
  }

}


module.exports = Product;
