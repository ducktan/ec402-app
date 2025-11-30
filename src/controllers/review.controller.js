const Review = require("../models/review.model");

// 1. Lấy tất cả review
exports.getAllReviews = async (req, res) => {
  try {
    // Dùng pool trực tiếp hoặc join users
    // Ở đây tạm dùng findAllByProduct với productId = null thì trả về tất cả
    const reviews = await Review.findAllByProduct(null); // chỉnh model cho productId null = all
    res.json(reviews);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

// 2. Lấy review theo id
exports.getReviewById = async (req, res) => {
  const { id } = req.params;

  try {
    const review = await Review.findById(id);
    if (!review) return res.status(404).json({ message: "Review not found" });

    res.json(review);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

// 3. Lấy review theo product id
exports.getReviewsByProduct = async (req, res) => {
  const { productId } = req.params;
  if (!productId) return res.status(400).json({ message: "Missing productId" });

  try {
    const data = await Review.findAllByProduct(productId);
    res.json(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

// 4. Thêm review (login required)
exports.addReview = async (req, res) => {
  const { productId, rating, comment } = req.body;
  const userId = req.user.id;

  if (!productId || !rating)
    return res.status(400).json({ message: "Missing required fields" });

  try {
    const review = await Review.create({
      product_id: productId,
      user_id: userId,
      rating,
      comment,
    });

    res.status(201).json(review);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

// 5. Sửa review (login required + chỉ owner mới sửa)
exports.updateReview = async (req, res) => {
  const { id } = req.params;
  const { rating, comment } = req.body;
  const userId = req.user.id;

  try {
    const review = await Review.findById(id);
    if (!review) return res.status(404).json({ message: "Review not found" });
    if (review.user_id !== userId)
      return res.status(403).json({ message: "Not authorized" });

    const success = await Review.update(id, { rating, comment });
    if (!success)
      return res.status(400).json({ message: "Nothing to update" });

    res.json({ message: "Review updated successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};

// 6. Xóa review (login required + chỉ owner mới xoá)
exports.deleteReview = async (req, res) => {
  const { id } = req.params;
  const userId = req.user.id;

  try {
    const review = await Review.findById(id);
    if (!review) return res.status(404).json({ message: "Review not found" });
    if (review.user_id !== userId)
      return res.status(403).json({ message: "Not authorized" });

    const success = await Review.delete(id);
    if (!success)
      return res.status(400).json({ message: "Delete failed" });

    res.json({ message: "Review deleted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Internal server error" });
  }
};
