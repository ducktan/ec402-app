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
      // ==== AppBar bình thường ở trên ====
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: TColors.black),
        elevation: 0,
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: TColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==== Banner full width, cách xa AppBar ====
            Padding(
              padding: const EdgeInsets.only(top: TSizes.defaultSpace),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: Image.asset(
                  TImages.promoBanner1,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ==== Section Heading "Products" ====
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: TSectionHeading(title: 'Products', showActionButton: false),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // ==== Grid sản phẩm ====
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
                  : Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: Text(
                          'No Data Found!',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
