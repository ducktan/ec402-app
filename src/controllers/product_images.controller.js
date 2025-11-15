const ProductImages = require("../models/product_images.model");
// ====== CREATE PRODUCT IMAGES ======
exports.createProductImages = async (req, res) => {
  try {
    const { product_id, image_url } = req.body;
    if (!product_id || !image_url) {
      return res
        .status(400)
        .json({ message: "Thiếu thông tin bắt buộc (product_id, image_url)." });
    }
    const newProductImages = await ProductImages.create({
      product_id,
      image_url,
    });
    res
      .status(201)
      .json({
        message: "Tạo hình ảnh cho sản phẩm thành công",
        data: newProductImages,
      });
  } catch (error) {
    console.error("Lỗi createProductImages:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
// ====== GET ALL PRODUCTS IMAGES ======
exports.getAllProductImages = async (req, res) => {
  try {
    const product_images = await ProductImages.findAll();
    res.json({ data: product_images });
  } catch (error) {
    console.error("Lỗi getAllProductImages:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
// ====== GET PRODUCT BY ID ======
exports.getProductImagesById = async (req, res) => {
  try {
    const id = req.params.id;
    const product_images = await ProductImages.findById(id);
    if (!product_images) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy hình ảnh sản phẩm." });
    }
    res.json({ data: product_images });
  } catch (error) {
    console.error("Lỗi getProductImagesById:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
// ====== UPDATE PRODUCT IMAGES ======
exports.updateProductImages = async (req, res) => {
  try {
    const id = req.params.id;
    const fieldsToUpdate = req.body;
    const product_images = await ProductImages.findById(id);
    if (!product_images) {
      return res.status(404).json({ message: "Không tìm thấy sản phẩm." });
    }
    const updated = await ProductImages.updateProductImages(id, fieldsToUpdate);
    res.json({
      message: "Cập nhật hình ảnh sản phẩm thành công",
      data: updated,
    });
  } catch (error) {
    console.error("Lỗi updateProductImages:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
// ====== DELETE PRODUCT IMAGES ======
exports.deleteProductImages = async (req, res) => {
  try {
    const id = req.params.id;
    const product_images = await ProductImages.findById(id);
    if (!product_images) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy hình ảnh sản phẩm." });
    }
    await ProductImages.deleteProductImages(id);
    res.json({ message: "Xoá hình ảnh sản phẩm thành công." });
  } catch (error) {
    console.error("Lỗi deleteProductImages:", error);
    res.status(500).json({ message: "Lỗi server", error: error.message });
  }
};
