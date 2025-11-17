const Wishlist = require("../models/wishlist.model");
const Product = require("../models/product.model"); //

// ===== 1. (GET) Lấy danh sách yêu thích =====
exports.getWishlist = async (req, res) => {
  try {
    // Lấy user ID từ token đã được giải mã (bởi authMiddleware)
    const userId = req.user.id;

    const products = await Wishlist.findByUser(userId);

    res.status(200).json(products);
  } catch (err) {
    console.error("Lỗi getWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ===== 2. (POST) Thêm vào danh sách yêu thích =====
exports.addToWishlist = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId } = req.body; // Lấy ID sản phẩm từ body của request

    if (!productId) {
      return res.status(400).json({ message: "Vui lòng cung cấp productId" });
    }

    // (Tùy chọn) Kiểm tra xem sản phẩm có thật không
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: "Sản phẩm không tồn tại" });
    }

    // Gọi hàm model để thêm
    const insertId = await Wishlist.add(userId, productId);

    if (insertId === 0) {
      // (insertId = 0 nghĩa là nó bị IGNORE do đã tồn tại)
      return res.status(200).json({ message: "Sản phẩm đã có trong wishlist" });
    }

    res.status(201).json({ message: "Đã thêm vào wishlist thành công" });
  } catch (err) {
    console.error("Lỗi addToWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};

// ===== 3. (DELETE) Xóa khỏi danh sách yêu thích =====
exports.removeFromWishlist = async (req, res) => {
  try {
    const userId = req.user.id;
    // Lấy ID sản phẩm từ URL (ví dụ: /api/wishlist/12)
    const { productId } = req.params;

    if (!productId) {
      return res.status(400).json({ message: "Vui lòng cung cấp productId trên URL" });
    }

    // Gọi hàm model để xóa
    const wasDeleted = await Wishlist.remove(userId, productId);

    if (!wasDeleted) {
      // (Không xóa được dòng nào, nghĩa là nó không có)
      return res.status(404).json({ message: "Sản phẩm không có trong wishlist" });
    }

    res.status(200).json({ message: "Đã xóa khỏi wishlist thành công" });
  } catch (err) {
    console.error("Lỗi removeFromWishlist:", err);
    res.status(500).json({ message: "Lỗi server" });
  }
};