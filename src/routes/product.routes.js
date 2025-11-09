const express = require("express");
const router = express.Router();
const ProductController = require("../controllers/product.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

router.post("/", authMiddleware, authorizeRole(["admin"]), ProductController.createProduct);
router.get("/", ProductController.getAllProducts);
router.get("/:id", ProductController.getProductById);
router.put("/:id", authMiddleware, authorizeRole(["admin"]), authMiddleware, ProductController.updateProduct);
router.delete("/:id", authMiddleware, authorizeRole(["admin"]), authMiddleware, ProductController.deleteProduct);

module.exports = router;
