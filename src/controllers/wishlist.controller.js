const Wishlist = require("../models/wishlist.model");
const Product = require("../models/product.model");

// ===== 1. (GET) Lấy tất cả wishlist (chỉ admin) =====
exports.getAllWishlist = async (req, res) => {
  try {
    const user = req.user;
    if (user.role !== "admin") {
      return res.status(403).json({ message: "Chỉ admin mới được xem toàn bộ wishlist" });
    }

    const [rows] = await Wishlist.findAll(); // Bạn cần tạo hàm findAll trong model
    res.status(200).json(rows);
  } catch (err) {
    console.error("Lỗi getAllWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ===== 2. (GET) Lấy wishlist của chính user =====
exports.getMyWishlist = async (req, res) => {
  try {
    const userId = req.user.id;
    const products = await Wishlist.findByUser(userId);
    res.status(200).json(products);
  } catch (err) {
    console.error("Lỗi getMyWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ===== 3. (POST) Thêm vào wishlist =====
exports.addToWishlist = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId } = req.body;

    if (!productId) {
      return res.status(400).json({ message: "Vui lòng cung cấp productId" });
    }

    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Sản phẩm không tồn tại" });
    }

    const insertId = await Wishlist.add(userId, productId);

    if (insertId === 0) {
      return res.status(200).json({ message: "Sản phẩm đã có trong wishlist" });
    }

    res.status(201).json({ message: "Đã thêm vào wishlist thành công" });
  } catch (err) {
    console.error("Lỗi addToWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ===== 4. (DELETE) Xóa wishlist (chỉ của chính user) =====
exports.removeFromWishlist = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId } = req.params;

    if (!productId) {
      return res.status(400).json({ message: "Vui lòng cung cấp productId trên URL" });
    }

    // Xóa chỉ được wishlist của chính mình
    const wasDeleted = await Wishlist.remove(userId, productId);

    if (!wasDeleted) {
      return res.status(404).json({ message: "Sản phẩm không có trong wishlist của bạn" });
    }

    res.status(200).json({ message: "Đã xóa khỏi wishlist thành công" });
  } catch (err) {
    console.error("Lỗi removeFromWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};
