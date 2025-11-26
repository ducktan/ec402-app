const Category = require("../models/category.model");

// ==========================
// TẠO DANH MỤC MỚI (ADMIN)
// ==========================
exports.createCategory = async (req, res) => {
  try {
    const { name, parent_id, avatar_url, banner_url } = req.body;
    if (!name) return res.status(400).json({ message: "Tên danh mục là bắt buộc." });

    const newCategory = await Category.create({ name, parent_id, avatar_url, banner_url });
    res.status(201).json({ message: "Tạo danh mục thành công.", data: newCategory });
  } catch (error) {
    console.error("Lỗi createCategory:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};

// ==========================
// LẤY TẤT CẢ DANH MỤC
// ==========================
exports.getCategories = async (req, res) => {
  try {
    const categories = await Category.getAll();
    res.json({ data: categories });
  } catch (error) {
    console.error("Lỗi getCategories:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};

// ==========================
// LẤY DANH MỤC THEO ID
// ==========================
exports.getCategoryById = async (req, res) => {
  try {
    const { id } = req.params;
    const category = await Category.getById(id);
    if (!category) return res.status(404).json({ message: "Không tìm thấy danh mục." });
    res.json({ data: category });
  } catch (error) {
    console.error("Lỗi getCategoryById:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};

// ==========================
// CẬP NHẬT DANH MỤC (ADMIN)
// ==========================
exports.updateCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, parent_id, avatar_url, banner_url } = req.body;

    const category = await Category.getById(id);
    if (!category) return res.status(404).json({ message: "Không tìm thấy danh mục." });

    const updated = await Category.update(id, { name, parent_id, avatar_url, banner_url });
    res.json({ message: "Cập nhật danh mục thành công.", data: updated });
  } catch (error) {
    console.error("Lỗi updateCategory:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};

// ==========================
// XOÁ DANH MỤC (ADMIN)
// ==========================
exports.deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const category = await Category.getById(id);
    if (!category) return res.status(404).json({ message: "Không tìm thấy danh mục." });

    await Category.delete(id);
    res.json({ message: "Xoá danh mục thành công." });
  } catch (error) {
    console.error("Lỗi deleteCategory:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};

// ==========================
// LẤY CÂY DANH MỤC
// ==========================
exports.getCategoryTree = async (req, res) => {
  try {
    const tree = await Category.getCategoryTree();
    res.json({ data: tree });
  } catch (error) {
    console.error("Lỗi getCategoryTree:", error);
    res.status(500).json({ message: "Lỗi server." });
  }
};
