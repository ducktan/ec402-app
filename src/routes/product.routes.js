const express = require("express");
const router = express.Router();
const ProductController = require("../controllers/product.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

// --- Search phải đặt trước ---
router.get("/search", ProductController.searchProducts);

router.post("/", authMiddleware, authorizeRole(["admin"]), ProductController.createProduct);
router.get("/", ProductController.getAllProducts);
router.get("/:id", ProductController.getProductById);
router.get("/:id/images", ProductController.getImagesByProductId);

router.put("/:id", authMiddleware, authorizeRole(["admin"]), ProductController.updateProduct);
router.delete("/:id", authMiddleware, authorizeRole(["admin"]), ProductController.deleteProduct);

// Related to category
router.get("/:id/related", ProductController.getRelatedProducts);


module.exports = router;
