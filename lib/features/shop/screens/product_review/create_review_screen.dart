import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Cần thêm thư viện này vào pubspec.yaml
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/create_review_controller.dart';

class CreateReviewScreen extends StatelessWidget {
  final int productId;
  final String productName;
  final String? productImage; // Để hiển thị cho đẹp

  const CreateReviewScreen({
    super.key,
    required this.productId,
    required this.productName,
    this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateReviewController(productId: productId));

    return Scaffold(
      appBar: AppBar(title: const Text("Viết đánh giá")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thông tin sản phẩm
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    image: productImage != null
                        ? DecorationImage(
                            image: NetworkImage(productImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: productImage == null
                      ? const Icon(Iconsax.image)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    productName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // 2. Chọn sao
            Center(
              child: Column(
                children: [
                  const Text("Chất lượng sản phẩm thế nào?"),
                  const SizedBox(height: 12),
                  Obx(
                    () => RatingBar.builder(
                      initialRating: controller.rating.value.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        controller.rating.value = rating.toInt();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Ô nhập bình luận
            TextFormField(
              controller: controller.commentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Hãy chia sẻ cảm nhận của bạn về sản phẩm này...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Nút Gửi
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => controller.submitReview(),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Gửi đánh giá"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}