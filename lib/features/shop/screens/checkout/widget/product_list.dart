// widgets/product_list.dart
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/images/t_rounded_image.dart';

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  const ProductList({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: cartItems.map((item) {
        final product = item['product'];
        final quantity = item['quantity'] ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TRoundedImage(imageUrl: product['avatar'] ?? TImages.noImage, width: 60, height: 60, borderRadius: 12, isNetworkImage: true, ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text("${product['title']} x $quantity",
                      style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600, color: colorScheme.onBackground))),
              Text("\$${((product['price'] ?? 0) * quantity).toStringAsFixed(2)}",
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
