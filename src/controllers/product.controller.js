const Product = require("../models/product.model");

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
