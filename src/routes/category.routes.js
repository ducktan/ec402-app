const express = require("express");
const router = express.Router();
const CategoryController = require("../controllers/category.controller");
const productController = require("../controllers/product.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

// Admin CRUD
router.post("/", authMiddleware, authorizeRole(["admin"]), CategoryController.createCategory);
router.put("/:id", authMiddleware, authorizeRole(["admin"]), CategoryController.updateCategory);
router.delete("/:id", authMiddleware, authorizeRole(["admin"]), CategoryController.deleteCategory);

// Public
router.get("/", CategoryController.getCategories);
router.get("/tree", CategoryController.getCategoryTree);
router.get("/:id", CategoryController.getCategoryById);

// Products by category
router.get("/:id/products", productController.getProductsByCategoryId);

module.exports = router;
