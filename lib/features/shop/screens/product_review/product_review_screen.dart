import 'package:flutter/material.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_item.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_summary.dart';
import 'package:ec402_app/features/shop/screens/product_review/widget/review_form.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá sản phẩm'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ReviewSummary(
              averageRating: 4.3,
              totalReviews: 234,
              starDistribution: {
                5: 150,
                4: 50,
                3: 20,
                2: 10,
                1: 4,
              },
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 0.8),
            const SizedBox(height: 12),
            const Text(
              'Tất cả đánh giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // ➕ Thêm widget form mới
            const ReviewForm(),

            // Danh sách đánh giá
            ListView.separated(
              itemCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) => const ReviewItem(
                userName: 'Nguyễn Văn A',
                rating: 5,
                date: '02/10/2025',
                comment:
                    'Sản phẩm dùng rất tốt, giao hàng nhanh và đóng gói cẩn thận!',
                imageUrls: [
                  'https://images.unsplash.com/photo-1608231387042-66d1773070a5?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2hvZXxlbnwwfHwwfHx8MA%3D%3D',
                  'https://snibbs.co/cdn/shop/files/SNIBBS_AUG02_StudioShoot-20.webp?v=1730775320&width=533'
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
