const Product = require("../models/product.model");

// ====== CREATE PRODUCT ======
exports.createProduct = async (req, res) => {
  try {
    const { brand_id, category_id, name, description, price, stock } = req.body;

    if (!name || !price) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc (name, price)." });
    }

    // Nếu không có brand_id, sử dụng ID của thương hiệu mặc định (ví dụ: 1)
    const defaultBrandId = 1; // Thay thế bằng ID của bản ghi 'No Brand' trong bảng brands
    
    const newProduct = await Product.create({
      brand_id: brand_id || defaultBrandId,
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

  // Update product images
  exports.updateProductImages = async (req, res) => {
    try {
      const { id } = req.params;
      const { images } = req.body;

      if (!images || !Array.isArray(images)) {
        return res.status(400).json({ 
          success: false, 
          message: "Danh sách ảnh không hợp lệ" 
        });
      }

      // Xóa tất cả ảnh cũ của sản phẩm
      await Product.deleteProductImages(id);

      // Thêm các ảnh mới
      const newImages = [];
      for (const imageUrl of images) {
        const newImage = await Product.addProductImage(id, imageUrl);
        newImages.push(newImage);
      }

      res.status(200).json({
        success: true,
        message: "Cập nhật ảnh sản phẩm thành công",
        images: newImages
      });
    } catch (error) {
      console.error('Lỗi khi cập nhật ảnh sản phẩm:', error);
      res.status(500).json({ 
        success: false, 
        message: "Lỗi server khi cập nhật ảnh sản phẩm" 
      });
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
