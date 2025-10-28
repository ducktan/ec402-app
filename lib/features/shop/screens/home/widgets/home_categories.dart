import 'package:ec402_app/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:ec402_app/features/shop/screens/home/home.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

import 'package:ec402_app/features/shop/screens/category/category_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔸 Danh sách danh mục mẫu
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Sports',
        'image': TImages.shoeIcon,
        'products': [
          {
            'title': 'Running Shoes',
            'price': '900.000đ',
            'shop': 'Nike Store',
            'image': TImages.productImage1,
          },
          {
            'title': 'Football',
            'price': '400.000đ',
            'shop': 'Adidas Store',
            'image': TImages.productImage1,
          },
        ]
      },
      {
        'title': 'Electronics',
        'image': TImages.shoeIcon,
        'products': [
          {
            'title': 'Samsung Phone',
            'price': '8.500.000đ',
            'shop': 'Samsung Official',
            'image': TImages.productImage1,
          },
          {
            'title': 'Laptop Acer',
            'price': '15.000.000đ',
            'shop': 'Acer Store',
            'image': TImages.productImage1,
          },
        ]
      },
      {
        'title': 'Jewelery',
        'image': TImages.shoeIcon,
        'products': [
          {
            'title': 'Gold Ring',
            'price': '3.200.000đ',
            'shop': 'Luxury Jewel',
            'image': TImages.productImage1,
          },
          {
            'title': 'Silver Necklace',
            'price': '1.100.000đ',
            'shop': 'Silver Star',
            'image': TImages.productImage1,
          },
        ]
      },
    ];

    return SizedBox(
      height: 80,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
        itemBuilder: (_, index) {
          final category = categories[index];

          return TVerticalImageText(
            image: category['image'],
            title: category['title'],
            onTap: () {
              // ✅ Khi nhấn -> chuyển sang CategoryProductsScreen
              Get.to(() => CategoryProductsScreen(
                    categoryName: category['title'],
                    products: List<Map<String, dynamic>>.from(category['products']),
                  ));
            },
          );
        },
      ),
    );
  }
}
