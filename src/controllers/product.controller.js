const Product = require("../models/product.model");
const db = require('../config/db'); 

// API: /api/shop/search?query=...&minPrice=...&maxPrice=...&categoryId=...&sort=...
exports.searchProducts = async (req, res) => {
    try {
        const { query, minPrice, maxPrice, categoryId, sort } = req.query; 
        
        console.log("🔍 Filter Params:", req.query);

        let sql = `
            SELECT p.*, b.name as brand_name, c.name as category_name 
            FROM products p
            LEFT JOIN brands b ON p.brand_id = b.id
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE 1=1 
        `;
        
        const params = [];

        // ... (Điều kiện tìm kiếm tên/giá/danh mục GIỮ NGUYÊN như cũ) ...
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

        // ✅ CẬP NHẬT PHẦN SẮP XẾP (SORT) THEO HÌNH ẢNH CỦA BẠN
        if (sort) {
            switch (sort) {
                case 'Name':        sql += ` ORDER BY p.name ASC`; break;
                case 'Lowest Price': sql += ` ORDER BY p.price ASC`; break;
                case 'Highest Price': sql += ` ORDER BY p.price DESC`; break;
                case 'Popular':     sql += ` ORDER BY p.review_count DESC`; break; // Phổ biến = nhiều review
                case 'Newest':      sql += ` ORDER BY p.created_at DESC`; break;   // Mới nhất
                case 'Suitable':    sql += ` ORDER BY p.rating_avg DESC`; break;   // Phù hợp = Rating cao
                default:            sql += ` ORDER BY p.created_at DESC`;
            }
        } else {
            sql += ` ORDER BY p.created_at DESC`;
        }

        const [products] = await db.query(sql, params);
        res.status(200).json({ success: true, count: products.length, data: products });
    } catch (error) {
        console.error("🔴 LỖI TÌM KIẾM:", error);
        res.status(500).json({ message: "Lỗi Server khi tìm kiếm" });
    }
};



// Lấy danh sách Brands
exports.getAllBrands = async (req, res) => {
  try {
    const [brands] = await db.query("SELECT * FROM brands ORDER BY name ASC");
    res.status(200).json({ success: true, data: brands });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Lấy danh sách Categories
exports.getAllCategories = async (req, res) => {
  try {
    const [categories] = await db.query("SELECT * FROM categories ORDER BY name ASC");
    res.status(200).json({ success: true, data: categories });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// =========================================================
// 2. CÁC HÀM CRUD CƠ BẢN (CŨ CỦA BẠN)
// =========================================================

// ====== CREATE PRODUCT ======
exports.createProduct = async (req, res) => {
  try {
    const { brand_id, category_id, name, description, price, stock } = req.body;

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

// ====== GET IMAGES BY PRODUCT ID ======
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
exports.updateProduct = async (req, res) => {
  try {
    const id = req.params.id;
    const fieldsToUpdate = req.body;

    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm." });
    }

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