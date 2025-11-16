const express = require("express");
const router = express.Router();
const CategoryController = require("../controllers/category.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

// ==========================
// ROUTES CHO CATEGORY
// ==========================

// 👉 Admin được tạo danh mục
router.post("/", authMiddleware, authorizeRole(["admin"]), CategoryController.createCategory);

// 👉 Admin được cập nhật danh mục
router.put("/:id", authMiddleware, authorizeRole(["admin"]), CategoryController.updateCategory);

// 👉 Admin được xóa danh mục
router.delete("/:id", authMiddleware, authorizeRole(["admin"]), CategoryController.deleteCategory);

// 👉 Public route (ai cũng xem được)
router.get("/", CategoryController.getCategories);
router.get("/tree", CategoryController.getCategoryTree);
router.get("/:id", CategoryController.getCategoryById);

module.exports = router;
