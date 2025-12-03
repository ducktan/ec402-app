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
  // ====== SEARCH PRODUCTS (lọc + sắp xếp) ======
  static async search({ query, minPrice, maxPrice, categoryId, sort }) {
    try {
      let sql = `
        SELECT p.*, b.name AS brand_name, c.name AS category_name
        FROM products p
        LEFT JOIN brands b ON p.brand_id = b.id
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE 1 = 1
      `;

      const params = [];

      // 1. Tìm theo tên hoặc mô tả
      if (query && query !== "null" && query.trim() !== "") {
        sql += ` AND (p.name LIKE ? OR p.description LIKE ?)`;
        params.push(`%${query}%`, `%${query}%`);
      }

      // 2. Lọc theo khoảng giá
      const min = parseFloat(minPrice);
      const max = parseFloat(maxPrice);

      if (!isNaN(min) && min > 0) {
        sql += ` AND p.price >= ?`;
        params.push(min);
      }

      if (!isNaN(max) && max > 0) {
        sql += ` AND p.price <= ?`;
        params.push(max);
      }

      // 3. Lọc theo danh mục
      if (categoryId && categoryId !== "null") {
        sql += ` AND p.category_id = ?`;
        params.push(categoryId);
      }

      // 4. Sắp xếp
      if (sort && sort !== "null") {
        switch (sort) {
          case "Name":
            sql += ` ORDER BY p.name ASC`;
            break;
          case "Lowest Price":
            sql += ` ORDER BY p.price ASC`;
            break;
          case "Highest Price":
            sql += ` ORDER BY p.price DESC`;
            break;
          case "Newest":
            sql += ` ORDER BY p.created_at DESC`;
            break;
          case "Popular":
            sql += ` ORDER BY p.review_count DESC`;
            break;
          case "Suitable":
            sql += ` ORDER BY p.rating_avg DESC`;
            break;
          default:
            sql += ` ORDER BY p.name ASC`;
        }
      } else {
        sql += ` ORDER BY p.name ASC`;
      }

      const [rows] = await pool.query(sql, params);
      return rows;
    } catch (error) {
      console.error("🔴 Lỗi search products:", error);
      throw error;
    }
  }



  // ====== GET RELATED PRODUCTS ======
  static async findRelated(productId) {
    const [rows] = await pool.query(
      `
        SELECT p.*
        FROM products p
        WHERE p.category_id = (
            SELECT category_id FROM products WHERE id = ?
        )
        AND p.id != ?
        ORDER BY p.id DESC
        LIMIT 20
      `,
      [productId, productId]
    );

    return rows;
  }

}


module.exports = Product;
