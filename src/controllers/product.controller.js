const Product = require("../models/product.model");
const db = require('../config/db');
// ====== CREATE PRODUCT ======
exports.createProduct = async (req, res) => {
  try {
    const { brand_id, category_id, name, description, price, stock, image_url } = req.body;

    if (!brand_id || !name || !price) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc (brand_id, name, price)." });
    }

    const newProduct = await Product.create({
      brand_id,
      category_id,
      name,
      description,
      price,
      stock: stock || 0,
      image_url: image_url || null,
    });

    res.status(201).json({
      message: "Tạo sản phẩm thành công",
      data: newProduct,
    });
  } catch (error) {
    console.error("Lỗi createProduct:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====== GET ALL PRODUCTS ======
exports.getAllProducts = async (req, res) => {
  try {
    const products = await Product.findAll();
    res.json({ data: products });
  } catch (error) {
    console.error("Lỗi getAllProducts:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====== GET PRODUCT BY ID ======
exports.getProductById = async (req, res) => {
  try {
    const id = req.params.id;
    const product = await Product.findById(id);

    if (!product) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm." });
    }

    res.json({ data: product });
  } catch (error) {
    console.error("Lỗi getProductById:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

exports.getImagesByProductId = async (req, res) => {
  try {
    const { id } = req.params;
    const images = await Product.findImgByProductId(id);

    res.status(200).json({
      success: true,
      productId: id,
      images,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

// ====== UPDATE PRODUCT ======
// ====== UPDATE PRODUCT ======
exports.updateProduct = async (req, res) => {
  try {
    const id = req.params.id;
    const fieldsToUpdate = req.body;

    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm." });
    }

    // Cho phép update cả image_url
    const updated = await Product.updateProduct(id, fieldsToUpdate);
    res.json({
      message: "Cập nhật sản phẩm thành công",
      data: updated,
    });
  } catch (error) {
    console.error("Lỗi updateProduct:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====== DELETE PRODUCT ======
exports.deleteProduct = async (req, res) => {
  try {
    const id = req.params.id;

    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm." });
    }

    await Product.deleteProduct(id);
    res.json({ message: "Xoá sản phẩm thành công." });
  } catch (error) {
    console.error("Lỗi deleteProduct:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};

// ====== GET PRODUCTS BY BRAND ID ======
exports.getProductsByBrandId = async (req, res) => {
  const brandId = req.params.id; // /api/brands/:id/products
  try {
    const products = await Product.findByBrandId(brandId);

    res.status(200).json({
      success: true,
      count: products.length,
      data: products,
    });
  } catch (error) {
    console.log("!!! LỖI TẠI getProductsByBrandId:", error);
    res.status(500).json({ success: false, message: 'Server Error', error: error.message });
  }
};

// ====== GET PRODUCTS BY CATEGORY ID ======
exports.getProductsByCategoryId = async (req, res) => {
  const categoryId = req.params.id; // /api/categories/:id/products
  try {
    const products = await Product.findByCategoryId(categoryId);

    res.status(200).json({
      success: true,
      count: products.length,
      data: products,
    });
  } catch (error) {
    console.log("!!! LỖI TẠI getProductsByCategoryId:", error);
    res.status(500).json({ success: false, message: 'Server Error', error: error.message });
  }
};

// API Tìm kiếm & Lọc sản phẩm
// GET /api/shop/search?query=...&minPrice=...&maxPrice=...&categoryId=...&sort=...
exports.searchProducts = async (req, res) => {
  try {
    const { query, minPrice, maxPrice, categoryId, sort } = req.query;

    console.log("🔍 Search Params:", req.query);

    // Câu truy vấn cơ bản
    let sql = `
            SELECT p.*, b.name as brand_name, c.name as category_name 
            FROM products p
            LEFT JOIN brands b ON p.brand_id = b.id
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE 1=1 
        `;

    const params = [];

    // 1. Tìm theo từ khóa (Tên hoặc Mô tả)
    if (query) {
      sql += ` AND (p.name LIKE ? OR p.description LIKE ?)`;
      params.push(`%${query}%`, `%${query}%`);
    }

    // 2. Lọc theo khoảng giá
    if (minPrice) {
      sql += ` AND p.price >= ?`;
      params.push(minPrice);
    }
    if (maxPrice) {
      sql += ` AND p.price <= ?`;
      params.push(maxPrice);
    }

    // 3. Lọc theo danh mục
    if (categoryId) {
      sql += ` AND p.category_id = ?`;
      params.push(categoryId);
    }

    // 4. Sắp xếp (Sort)
    if (sort) {
      switch (sort) {
        case 'Name': sql += ` ORDER BY p.name ASC`; break;
        case 'Lowest Price': sql += ` ORDER BY p.price ASC`; break;
        case 'Highest Price': sql += ` ORDER BY p.price DESC`; break;
        case 'Newest': sql += ` ORDER BY p.created_at DESC`; break;
        case 'Popular': sql += ` ORDER BY p.review_count DESC`; break; // Giả định có cột review_count
        case 'Suitable': sql += ` ORDER BY p.rating_avg DESC`; break;   // Giả định có cột rating_avg
        default: sql += ` ORDER BY p.name ASC`;
      }
    } else {
      sql += ` ORDER BY p.name ASC`;
    }

    const [products] = await db.query(sql, params);
    res.status(200).json({ success: true, count: products.length, data: products });

  } catch (error) {
    console.error("🔴 Lỗi Search:", error);
    res.status(500).json({ message: "Lỗi Server" });
  }
};
