const express = require("express");
const router = express.Router();
const ProductController = require("../controllers/product.controller");

// Tất cả các route đều không cần xác thực
router.post("/", ProductController.createProduct);
router.get("/", ProductController.getAllProducts);
router.get("/:id", ProductController.getProductById);
router.put("/:id", ProductController.updateProduct);
router.delete("/:id", ProductController.deleteProduct);
router.get("/:id/images", ProductController.getImagesByProductId);
router.put("/:id/images", ProductController.updateProductImages);

module.exports = router;
