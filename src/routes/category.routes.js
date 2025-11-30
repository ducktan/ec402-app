const express = require("express");
const router = express.Router();
const CategoryController = require("../controllers/category.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

// ==========================
// ROUTES CHO CATEGORY
// ==========================

// 👉 Public routes for categories
router.post("/", CategoryController.createCategory);
router.put("/:id", CategoryController.updateCategory);
router.delete("/:id", CategoryController.deleteCategory);
router.get("/", CategoryController.getCategories);
router.get("/tree", CategoryController.getCategoryTree);
router.get("/:id", CategoryController.getCategoryById);

module.exports = router;
