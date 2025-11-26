import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/appbar/primary_header_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:ec402_app/common/widgets/images/t_rounded_image.dart';
import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:ec402_app/features/shop/screens/search/search_screen.dart';
import 'package:ec402_app/features/shop/screens/product_detail/product_detail_screen.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    // Load data ngay khi screen mở
    productController.loadProducts();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  TSearchContainer(
                    text: 'Search in Store',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),

                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: TColors.white,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        THomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TPromoSlider(
                    banners: [
                      TImages.promoBanner1,
                      TImages.promoBanner1,
                      TImages.promoBanner1,
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Obx(() {
                    if (productController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = productController.products;

                    return TGirdLayout(
                      iTemCount: products.length,
                      childAspectRatio: 0.55,
                      itemBuilder: (_, index) {
                        final product = products[index];
                        return TProductCardVertical(
                          title: product['name'] ?? 'Unknown',
                          price: "${product['price']} VNĐ",
                          shop: "Brand ${product['brand_id'] ?? ''}",
                          imageUrl:
                              product['image_url'] ??
                              "https://via.placeholder.com/150", // fallback nếu null
                          onTap: () => Get.to(() => ProductDetailScreen(product: product)),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
