import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ Rating
          Row(
            children: const [
              Icon(Iconsax.star5, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text(
                '4.8 (215)',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🏷️ Tên sản phẩm
          const Text(
            'Green Nike Sports Shoes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // 💰 Giá sản phẩm
          const Text(
            '\$112.6',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // 📦 Tình trạng kho
          Row(
            children: const [
              Icon(Iconsax.box, size: 18, color: Colors.green),
              SizedBox(width: 6),
              Text(
                'In Stock',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }
}
