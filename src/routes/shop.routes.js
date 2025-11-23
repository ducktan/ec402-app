const express = require('express');
const router = express.Router();
const productController = require('../controllers/product.controller');

// Kiểm tra kỹ dòng này:
router.get('/search', productController.searchProducts);   
router.get('/brands', productController.getAllBrands);     
router.get('/categories', productController.getAllCategories); 

module.exports = router;