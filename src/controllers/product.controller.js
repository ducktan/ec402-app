const Product = require("../models/product.model");

// ====== CREATE ======
exports.createProduct = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ message: "Chỉ admin mới được thêm sản phẩm." });
    }

    const { category_id, name, description, price, stock } = req.body;
    if (!name || !price)
      return res.status(400).json({ message: "Tên và giá sản phẩm là bắt buộc." });

    const seller_id = req.user.id;
    const newProduct = await Product.create({
      seller_id,
      category_id,
      name,
      description,
      price,
      stock,
    });

    res.status(201).json({ message: "Tạo sản phẩm thành công", data: newProduct });
  } catch (error) {
    console.error("Lỗi createProduct:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ====== READ ALL ======
exports.getAllProducts = async (req, res) => {
  try {
    const { category_id } = req.query;
    const products = await Product.findAll({ category_id });
    res.json({ data: products });
  } catch (error) {
    console.error("Lỗi getAllProducts:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ====== READ ONE ======
exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ message: "Không tìm thấy sản phẩm." });
    res.json({ data: product });
  } catch (error) {
    console.error("Lỗi getProductById:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ====== UPDATE ======
exports.updateProduct = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ message: "Chỉ admin mới được sửa sản phẩm." });
    }

    const id = req.params.id;
    const product = await Product.findById(id);
    if (!product) return res.status(404).json({ message: "Không tìm thấy sản phẩm." });

    const fieldsToUpdate = req.body;
    const updated = await Product.updateProduct(id, fieldsToUpdate);

    res.json({ message: "Cập nhật sản phẩm thành công", data: updated });
  } catch (error) {
    console.error("Lỗi updateProduct:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ====== DELETE ======
exports.deleteProduct = async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ message: "Chỉ admin mới được xoá sản phẩm." });
    }

    const id = req.params.id;
    const product = await Product.findById(id);
    if (!product) return res.status(404).json({ message: "Không tìm thấy sản phẩm." });

    await Product.deleteProduct(id);
    res.json({ message: "Xoá sản phẩm thành công." });
  } catch (error) {
    console.error("Lỗi deleteProduct:", error);
    res.status(500).json({ message: "Lỗi server" });
  }
};
