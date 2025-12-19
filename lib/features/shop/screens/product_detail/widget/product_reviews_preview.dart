import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/review_controller.dart';
import '../../product_review/product_review_screen.dart';

class ProductReviewsPreview extends StatelessWidget {
  final int productId;

  const ProductReviewsPreview({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchReviewsByProduct(productId);
    });

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

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
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  "${controller.avgRating.value.toStringAsFixed(1)}/5 (${controller.reviewsCount.value} đánh giá)",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Hiển thị 1-2 review mẫu
            ...controller.previewReviews.map((r) => _buildReviewItem(
              name: r['user_name'] ?? 'Anonymous',
              comment: r['comment'] ?? '',
              avatarUrl: r['user_avatar'], // avatar user
            )),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => ProductReviewsScreen(productId: productId));
                },
                child: const Text("Xem tất cả đánh giá"),
              ),
            ),
          ],
        ),
      );
    });
  }

  static Widget _buildReviewItem({
    required String name,
    required String comment,
    String? avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
          ),
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
