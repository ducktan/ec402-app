import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_item.dart';
import '../../controllers/review_controller.dart';

class AllReviewsScreen extends StatelessWidget {
  final int productId;

  const AllReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchReviews(productId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Tất cả đánh giá'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reviews.isEmpty) {
          return const Center(
            child: Text("Chưa có đánh giá nào cho sản phẩm này."),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reviews.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) {
            final review = controller.reviews[index];

            // ✅ SỬA LỖI: Chuyển rating về kiểu int
            // Lấy giá trị double trước (phòng khi data là "4.5") rồi .toInt()
            final double ratingVal =
                double.tryParse(review['rating'].toString()) ?? 5.0;
            final int rating = ratingVal.toInt();

            // Xử lý Ngày
            final dateStr = review['created_at']?.toString();
            final date = (dateStr != null && dateStr.length >= 10)
                ? dateStr.substring(0, 10)
                : 'N/A';

            return ReviewItem(
              userName: review['user_name']?.toString() ?? 'Anonymous',
              comment: review['comment']?.toString() ?? '',
              rating: rating, // Bây giờ biến này là int, sẽ không còn lỗi đỏ
              date: date,
              imageUrls: const [],
            );
          },
        );
      }),
    );
  }
}