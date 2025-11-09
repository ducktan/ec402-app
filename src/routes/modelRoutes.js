const express = require('express');
const router = express.Router();
const brandController = require('../controllers/brandController');

// Định nghĩa các routes cho CRUD

// CREATE: POST /api/v1/brands
router.post('/', brandController.createBrand);

// READ (All): GET /api/v1/brands
router.get('/', brandController.getAllBrands);

// READ (One): GET /api/v1/brands/:id
router.get('/:id', brandController.getBrandById);

// UPDATE: PUT /api/v1/brands/:id
router.put('/:id', brandController.updateBrand);

// DELETE: DELETE /api/v1/brands/:id
router.delete('/:id', brandController.deleteBrand);

module.exports = router;