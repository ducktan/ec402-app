import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/common/widgets/store/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/products.card/cart_menu_icon.dart';
import 'package:ec402_app/common/widgets/store/category/category_section.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/features/shop/screens/brand/all_brand.dart';
import 'package:ec402_app/features/shop/screens/brand/brand_product.dart';
import 'package:ec402_app/features/shop/screens/cart/cart.dart';

import '../../controllers/brand_controller.dart';
import '../../controllers/category_controller.dart';
import '../../../../common/widgets/layouts/gird_layout.dart';
import '../../screens/product_detail/product_detail_screen.dart';
import '../../screens/search/search_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final brandCtrl = Get.put(BrandController());
  final categoryCtrl = Get.put(CategoryController());

  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Store',
            style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TCartCounterIcon(
              onPressed: () => Get.to(() => const CartScreen()),
              iconColor: TColors.black,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SEARCH + FEATURED BRANDS HEADER
          SliverPadding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                GestureDetector(
                  onTap: () {
                    Get.to(() => SearchScreen()); // Hoặc alias nếu bị conflict
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search in Store',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Brands',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => const AllBrandsScreen()),
                      child: const Text(
                        'View All',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
              ]),
            ),
          ),

          // BRAND GRID
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
            ),
            sliver: Obx(() {
              if (brandCtrl.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (brandCtrl.brands.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No brands available")),
                );
              }

              return SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final brand = brandCtrl.brands[index];
                  return TBrandCard(
                    showBorder: true,
                    brandName: brand['name'],
                    productCount: "${brand['productCount'] ?? 0} products",
                    icon: brand['logo_url'] ?? TImages.clothIcon,
                    onTap: () =>
                        Get.to(() => BrandProducts(brandId: brand['id'])),
                  );
                }, childCount: brandCtrl.brands.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 80,
                  crossAxisSpacing: TSizes.spaceBtwItems,
                  mainAxisSpacing: TSizes.spaceBtwItems,
                ),
              );
            }),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: TSizes.spaceBtwSections),
          ),

          // CATEGORY SELECTOR (API) - với padding
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: TSizes.spaceBtwSections / 2,
            ),
            sliver: SliverToBoxAdapter(
              child: Obx(() {
                if (categoryCtrl.isLoadingCategories.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final parentCategories = categoryCtrl.categories
                    .where((c) => c['parent_id'] == null)
                    .toList();

                if (parentCategories.isEmpty) {
                  return const Center(child: Text("No categories found"));
                }

                return CategorySection(
                  categories: parentCategories
                      .map((c) => c['name'] as String)
                      .toList(),
                  selectedIndex: _selectedCategoryIndex,
                  onSelect: (index) {
                    setState(() => _selectedCategoryIndex = index);
                    categoryCtrl.selectCategory(parentCategories[index]['id']);
                  },
                );
              }),
            ),
          ),

          // PRODUCT GRID (API) - dùng TGirdLayout
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
              vertical: TSizes.spaceBtwSections / 2,
            ),
            sliver: SliverToBoxAdapter(
              child: Obx(() {
                if (categoryCtrl.isLoadingProducts.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryCtrl.products.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                final products = categoryCtrl.products;

                return TGirdLayout(
                  iTemCount: products.length,
                  childAspectRatio: 0.55,
                  itemBuilder: (_, index) {
                    final product = products[index];

                    return TProductCardVertical(
                      title: product['name'] ?? 'Unknown',
                      price: "${product['price']} VNĐ",
                      shop: product['seller_name'] ?? "Shop",
                      imageUrl: product['image_url'] ?? TImages.productImage1,
                      onTap: () {
                        print("→ Tap: ${product['name']}");
                        Get.to(() => ProductDetailScreen(product: product));
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
