import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../product_review/all_reviews_screen.dart'; // Import màn hình mới

class ProductReviewsPreview extends StatelessWidget {
  final int productId; // Nhận Product ID

  const ProductReviewsPreview({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đánh giá sản phẩm",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // ... (Phần hiển thị sao trung bình giữ nguyên) ...
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Iconsax.star1, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                "4.8/5 (120 đánh giá)",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Hiển thị 1-2 review mẫu (có thể lấy từ controller nếu muốn dynamic luôn ở đây)
          _buildReviewItem(
            name: "Nguyễn Văn A",
            comment: "Sản phẩm rất đẹp và đúng mô tả!",
          ),

          const SizedBox(height: 6),

          // Nút Chuyển trang
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Chuyển sang màn hình danh sách đầy đủ
                Get.to(() => AllReviewsScreen(productId: productId));
              },
              child: const Text("Xem tất cả đánh giá"),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReviewItem({
    required String name,
    required String comment,
  }) {
    // ... (Giữ nguyên code UI item) ...
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}