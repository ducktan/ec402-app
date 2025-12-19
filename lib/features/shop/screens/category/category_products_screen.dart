import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import '../../../../common/widgets/layouts/gird_layout.dart';
import '../../controllers/brand_controller.dart';
import 'package:get/get.dart';

import '../../controllers/category_controller.dart';
import '../product_detail/product_detail_screen.dart';

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
    final brandController = Get.put(BrandController());
    final categoryController = Get.put(CategoryController());

    return Scaffold(
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
            // Banner
            // Banner của category
Padding(
  padding: const EdgeInsets.only(top: TSizes.defaultSpace),
  child: ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    child: Obx(() {
      // Lấy banner_url từ category đã chọn
      final bannerUrl = categoryController.selectedCategory['banner_url'] ??
          "https://i.pinimg.com/736x/3c/d6/b0/3cd6b0a044375c3a1b9da0a8c04e91dd.jpg";

      return Image.network(
        bannerUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback nếu load URL lỗi
          return Image.network(
            "https://i.pinimg.com/736x/3c/d6/b0/3cd6b0a044375c3a1b9da0a8c04e91dd.jpg",
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          );
        },
      );
    }),
  ),
),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Section Heading
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: TSectionHeading(
                title: 'Products',
                showActionButton: false,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Grid sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultSpace,
              ),
              child: products.isNotEmpty
                  ? TGirdLayout(
                      iTemCount: products.length,
                      childAspectRatio: 0.55,
                      itemBuilder: (_, index) {
                        final product = products[index];

                        // Trả về Obx widget trực tiếp
                        return Obx(() {
                          
                          final shopName = brandController
                              .getBrandName(product['brand_id']);

                          return TProductCardVertical(
                            title: product['name'] ?? "Unknown",
                            price: "${product['price'] ?? 0} VNĐ",
                            shop: shopName,
                            imageUrl: product['image_url'] ?? "",
                            onTap: () {
                              print("→ Tap: ${product['name']}");
                              Get.to(() => ProductDetailScreen(product: product));
                            },
                          );
                        });
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Center(
                        child: Text(
                          'No Data Found!',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
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
