import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/features/shop/screens/product_detail/product_detail_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TSortableProducts extends StatelessWidget {
  const TSortableProducts({super.key});

  @override
  Widget build(BuildContext context) {
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
          iTemCount: 8, // ✅ fix chính tả
          itemBuilder: (_, index) => TProductCardVertical(
            title: "Red Shoes $index",
            price: "500.000đ",
            shop: "Nike Official",
            imageUrl: "https://picsum.photos/id/${index + 10}/200/200",
            onTap: () => Get.to(() => const ProductDetailScreen()),
          ),
        ),
      ],
    );
  }
}