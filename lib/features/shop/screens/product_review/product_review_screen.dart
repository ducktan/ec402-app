import 'package:flutter/material.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_item.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_summary.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_form.dart';
import '../../controllers/review_controller.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';

class ProductReviewsScreen extends StatelessWidget {
  final int productId;
  const ProductReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReviewController());

    // Load reviews khi mở màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchReviewsByProduct(productId);
    });

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Đánh giá sản phẩm'),
        showBackArrow: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = controller.reviews;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Summary ---
              ReviewSummary(
                averageRating: controller.avgRating.value,
                totalReviews: controller.reviewsCount.value,
                starDistribution: controller.starDistribution,
              ),
              const SizedBox(height: 24),
              const Divider(thickness: 0.8),
              const SizedBox(height: 12),
              const Text(
                'Tất cả đánh giá',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // --- Form thêm review ---
              ReviewForm(productId: productId),

              const SizedBox(height: 12),

              // --- Danh sách review ---
              if (reviews.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Chưa có đánh giá nào cho sản phẩm này."),
                  ),
                )
              else
                ListView.separated(
                  itemCount: reviews.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, index) {
                    final review = reviews[index];

                    // Rating int
                    final double ratingVal =
                        double.tryParse(review['rating'].toString()) ?? 5.0;
                    final int rating = ratingVal.toInt();

                    // Ngày
                    final dateStr = review['created_at']?.toString();
                    final date = (dateStr != null && dateStr.length >= 10)
                        ? dateStr.substring(0, 10)
                        : 'N/A';
                    final isOwner = review['user_id'] == controller.userId;

                    return ReviewItem(
                      userName: review['user_name']?.toString() ?? 'Anonymous',
                      comment: review['comment']?.toString() ?? '',
                      rating: rating,
                      date: date,
                      avatarUrl: review['user_avatar']?.toString(),
                      imageUrls: [],
                      onDelete: isOwner
                          ? () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Xác nhận'),
                                  content: const Text(
                                    'Bạn có chắc muốn xóa đánh giá này?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Huỷ'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Xóa'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed ?? false) {
                                await controller.deleteReview(
                                  reviewId: review['id'],
                                  productId: productId,
                                );
                              }
                            }
                          : null,
                      onEdit: isOwner
                          ? () async {
                              // Hiển thị dialog hoặc bottom sheet để chỉnh sửa
                              final result = await showModalBottomSheet<bool>(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),
                                  child: ReviewForm(
                                    productId: productId,
                                    existingReview:
                                        review, // truyền review hiện tại để sửa
                                  ),
                                ),
                              );
                              if (result == true) {
                                // Nếu người dùng submit, refresh danh sách
                                await controller.fetchReviewsByProduct(
                                  productId,
                                );
                              }
                            }
                          : null,
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
