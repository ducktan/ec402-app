const Cart = require("../models/cart.model");

exports.getMyCart = async (req, res) => {
  try {
    const userId = req.user.id;
    const { cart, items } = await Cart.getCartWithItems(userId);
    res.status(200).json({ cart, items });
  } catch (err) {
    console.error("getMyCart error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.addItem = async (req, res) => {
  try {
    const userId = req.user.id;
    const { product_id, quantity } = req.body;
    if (!product_id || !quantity || quantity <= 0) {
      return res.status(400).json({ message: "product_id and positive quantity are required" });
    }
    const item = await Cart.addItem(userId, Number(product_id), Number(quantity));
    res.status(201).json({ message: "Item added to cart", item });
  } catch (err) {
    console.error("addItem error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.updateItem = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId } = req.params;
    const { quantity } = req.body;
    if (quantity === undefined || quantity <= 0) {
      return res.status(400).json({ message: "quantity must be > 0" });
    }
    const ok = await Cart.updateItemQuantity(userId, Number(productId), Number(quantity));
    if (!ok) return res.status(404).json({ message: "Item not found" });
    res.status(200).json({ message: "Item updated" });
  } catch (err) {
    console.error("updateItem error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.removeItem = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId } = req.params;
    const ok = await Cart.removeItem(userId, Number(productId));
    if (!ok) return res.status(404).json({ message: "Item not found" });
    res.status(200).json({ message: "Item removed" });
  } catch (err) {
    console.error("removeItem error:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.clearCart = async (req, res) => {
  try {
    const userId = req.user.id;
    await Cart.clearCart(userId);
    res.status(200).json({ message: "Cart cleared" });
  } catch (err) {
    console.error("clearCart error:", err);
    res.status(500).json({ message: "Server error" });
  }
};
