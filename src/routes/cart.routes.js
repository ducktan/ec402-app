const express = require("express");
const router = express.Router();
const CartController = require("../controllers/cart.controller");
const { authMiddleware } = require("../middlewares/auth.middleware");

// Get current user's cart
router.get("/", authMiddleware, CartController.getMyCart);

// Add item to cart
router.post("/items", authMiddleware, CartController.addItem);

// Update quantity for a product in cart
router.put("/items/:productId", authMiddleware, CartController.updateItem);

// Remove a product from cart
router.delete("/items/:productId", authMiddleware, CartController.removeItem);

// Clear cart
router.delete("/", authMiddleware, CartController.clearCart);

module.exports = router;
