const express = require("express");
const router = express.Router();
const ProductImagesController = require("../controllers/product_images.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");
router.post(
  "/",
  authMiddleware,
  authorizeRole(["admin"]),
  ProductImagesController.createProductImages
);
router.get(
  "/",
  authMiddleware,
  authorizeRole(["admin"]),
  ProductImagesController.getAllProductImages
);
router.get(
  "/:id",
  authMiddleware,
  authorizeRole(["admin"]),
  ProductImagesController.getProductImagesById
);
router.put(
  "/:id",
  authMiddleware,
  authorizeRole(["admin"]),
  authMiddleware,
  ProductImagesController.updateProductImages
);
router.delete(
  "/:id",
  authMiddleware,
  authorizeRole(["admin"]),
  authMiddleware,
  ProductImagesController.deleteProductImages
);
module.exports = router;
