import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/review_controller.dart';

class ReviewForm extends StatefulWidget {
  final int productId;
  final Map<String, dynamic>? existingReview; // Nếu sửa review

  const ReviewForm({super.key, required this.productId, this.existingReview});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  late final ReviewController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ReviewController>();

    // Nếu có review hiện tại, điền dữ liệu sẵn
    if (widget.existingReview != null) {
      selectedRating = widget.existingReview!['rating'] ?? 0;
      _commentController.text = widget.existingReview!['comment'] ?? '';
    }
  }

  void _submitReview() async {
    final comment = _commentController.text.trim();

    if (selectedRating == 0 || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung và chọn số sao')),
      );
      return;
    }

    bool success = false;
    if (widget.existingReview != null) {
      // --- Update review ---
      success = await controller.updateReview(
        reviewId: widget.existingReview!['id'],
        productId: widget.productId,
        rating: selectedRating,
        comment: comment,
      );
    } else {
      // --- Thêm review mới ---
      success = await controller.addReview(
        productId: widget.productId,
        rating: selectedRating,
        comment: comment,
      );
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingReview != null
              ? 'Đã cập nhật đánh giá!'
              : 'Đã gửi đánh giá thành công!'),
        ),
      );
      if (widget.existingReview == null) {
        _commentController.clear();
        setState(() => selectedRating = 0);
      }
      // Đóng bottom sheet nếu đang edit
      if (widget.existingReview != null) Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thao tác thất bại, thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existingReview != null
                  ? 'Chỉnh sửa đánh giá'
                  : 'Viết đánh giá của bạn',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(5, (index) {
                final star = index + 1;
                return IconButton(
                  onPressed: () => setState(() => selectedRating = star),
                  icon: Icon(
                    star <= selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 28,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Chia sẻ trải nghiệm của bạn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  widget.existingReview != null ? 'Cập nhật đánh giá' : 'Gửi đánh giá',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
