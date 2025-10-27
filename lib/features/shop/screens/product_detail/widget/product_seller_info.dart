import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductSellerInfo extends StatelessWidget {
  final String sellerName;
  final String sellerAvatar;

  const ProductSellerInfo({
    super.key,
    required this.sellerName,
    required this.sellerAvatar,
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
            onPressed: () {},
            icon: const Icon(Iconsax.shop, size: 18),
            label: const Text("Xem shop"),
          )
        ],
      ),
    );
  }
}
