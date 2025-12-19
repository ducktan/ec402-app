import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/features/shop/screens/product_detail/product_detail_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TSortableProducts extends StatelessWidget {
  final List<Map<String, dynamic>>? products; // ✅ thêm parameter

  const TSortableProducts({super.key, this.products});

  @override
  Widget build(BuildContext context) {
    // Nếu không truyền products → dùng dữ liệu demo
    final displayProducts = products ??
        List.generate(
          8,
          (index) => {
            'name': "Red Shoes $index",
            'price': "500.000đ",
            'shop': "Nike Official",
            'image_url': "https://picsum.photos/id/${index + 10}/200/200",
          },
        );

    return Column(
      children: [
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          onChanged: (value) {},
          items: [
            'Name',
            'Higher Price',
            'Lower Price',
            'Sale',
            'Newest',
            'Popularity',
          ]
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
        ),

        const SizedBox(height: TSizes.spaceBtwSections),

        TGirdLayout(
          iTemCount: displayProducts.length,
          childAspectRatio: 0.55,
          itemBuilder: (_, index) {
            final product = displayProducts[index];
            return TProductCardVertical(
              title: product['name'] ?? "Unknown",
              price: product['price'] ?? "0 VNĐ",
              shop: product['shop'] ?? "",
              imageUrl: product['image_url'] ?? "",
              onTap: () {
                // nếu có màn product detail
                Get.to(() => ProductDetailScreen(product: product));
              },
            );
          },
        ),
      ],
    );
  }
}
