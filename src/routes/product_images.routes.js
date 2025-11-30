const express = require("express");
const router = express.Router();
const ProductImagesController = require("../controllers/product_images.controller");

// Public routes - no authentication required
router.post("/", ProductImagesController.createProductImages);
router.get("/", ProductImagesController.getAllProductImages);
router.get("/:id", ProductImagesController.getProductImagesById);
router.put("/:id", ProductImagesController.updateProductImages);
router.delete("/:id", ProductImagesController.deleteProductImages);

module.exports = router;
