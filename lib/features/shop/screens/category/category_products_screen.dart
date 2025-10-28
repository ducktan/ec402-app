import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> products;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TColors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: TColors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔸 Banner khuyến mãi full width
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.asset(
                TImages.promoBanner1,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover, // ✅ phủ full chiều ngang
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // 🔸 Tiêu đề
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: TSectionHeading(title: 'Products', showActionButton: false),
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // 🔸 Danh sách sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: products.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: TSizes.spaceBtwItems,
                        crossAxisSpacing: TSizes.spaceBtwItems,
                        mainAxisExtent: 280,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return TProductCardVertical(
                          title: product['title']!,
                          price: product['price']!,
                          shop: product['shop'],
                          imageUrl: product['image']!,
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        'No Data Found!',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}