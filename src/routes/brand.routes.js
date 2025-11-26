const express = require('express');
const router = express.Router();
const brandController = require('../controllers/brand.controller');
const productController = require('../controllers/product.controller');
const { authMiddleware } = require("../middlewares/auth.middleware");
const authorizeRole = require("../middlewares/authorizeRole");

// Định nghĩa các routes cho CRUD

// CREATE: POST /api/v1/brands
router.post('/', authMiddleware, authorizeRole(["admin"]), brandController.createBrand);

// READ (All): GET /api/v1/brands
router.get('/', brandController.getAllBrands);

// READ (One): GET /api/v1/brands/:id
router.get('/:id', brandController.getBrandById);

// UPDATE: PUT /api/v1/brands/:id
router.put('/:id', authMiddleware, authorizeRole(["admin"]), brandController.updateBrand);

// DELETE: DELETE /api/v1/brands/:id
router.delete('/:id', authMiddleware, authorizeRole(["admin"]), brandController.deleteBrand);

// GET PRODUCTS BY BRAND ID: GET /api/v1/brands/:id/products
router.get('/:id/products', productController.getProductsByBrandId);

module.exports = router;