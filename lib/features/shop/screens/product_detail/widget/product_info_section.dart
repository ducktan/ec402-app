import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductInfoSection extends StatelessWidget {
  final String name;
  final String price;
  final double rating;
  final int stock;

  const ProductInfoSection({
    super.key,
    required this.name,
    required this.price,
    required this.rating,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ⭐ Rating
          Row(
            children: [
              Icon(Iconsax.star5, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                "$rating (${stock} reviews)",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🏷️ Tên sản phẩm
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // 💰 Giá sản phẩm
          Text(
            "$price VNĐ",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // 📦 Tình trạng kho
          Row(
            children: [
              Icon(Iconsax.box, size: 18, color: stock > 0 ? Colors.green : Colors.red),
              const SizedBox(width: 6),
              Text(
                stock > 0 ? 'In Stock' : 'Out of Stock',
                style: TextStyle(color: stock > 0 ? Colors.green : Colors.red),
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
