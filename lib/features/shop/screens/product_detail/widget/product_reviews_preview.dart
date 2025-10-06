import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductReviewsPreview extends StatelessWidget {
  const ProductReviewsPreview({super.key});

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
          const SizedBox(height: 8),
          Row(
            children: const [
              Icon(Iconsax.star1, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text("4.8/5 (120 đánh giá)",
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          _buildReviewItem(
            name: "Nguyễn Văn A",
            comment: "Sản phẩm rất đẹp và đúng mô tả!",
          ),
          _buildReviewItem(
            name: "Trần Thị B",
            comment: "Giao hàng nhanh, đóng gói cẩn thận.",
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () {},
            child: const Text("Xem tất cả đánh giá"),
          )
        ],
      ),
    );
  }

  static Widget _buildReviewItem({required String name, required String comment}) {
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
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
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
