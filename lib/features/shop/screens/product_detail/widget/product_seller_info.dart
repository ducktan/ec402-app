import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/features/shop/screens/brand/brand_product.dart';

class ProductSellerInfo extends StatelessWidget {
  final String sellerName;
  final String sellerAvatar;
  final int brandId; // Thêm brandId

  const ProductSellerInfo({
    super.key,
    required this.sellerName,
    required this.sellerAvatar,
    required this.brandId, // bắt buộc khi tạo widget
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(sellerAvatar),
            radius: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              sellerName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to BrandProducts page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BrandProducts(
                    brandId: brandId, // dùng brandId từ parameter
                  ),
                ),
              );
            },
            icon: const Icon(Iconsax.shop, size: 18),
            label: const Text("Xem shop"),
          )
        ],
      ),
    );
  }
}
