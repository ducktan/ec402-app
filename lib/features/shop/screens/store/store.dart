import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/common/widgets/store/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/products.card/cart_menu_icon.dart';
import 'package:ec402_app/features/shop/screens/brand/all_brand.dart';
import 'package:ec402_app/features/shop/screens/brand/brand_product.dart';
import 'package:ec402_app/features/shop/screens/cart/cart.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:ec402_app/common/widgets/store/category/category_section.dart';
import '../../controllers/brand_controller.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final brandCtrl = Get.put(BrandController());

  final List<String> _categories = [
    'Sports',
    'Jewelery',
    'Electronics',
    'Clothes',
  ];

  int _selectedCategoryIndex = 0;

  final Map<String, List<Map<String, dynamic>>> _categoryProducts = {
    'Sports': [
      {
        'title': 'Running Shoes',
        'price': '900.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
      {
        'title': 'Football',
        'price': '400.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
    ],
    'Jewelery': [
      {
        'title': 'Gold Ring',
        'price': '3.200.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
      {
        'title': 'Silver Necklace',
        'price': '1.100.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
    ],
    'Electronics': [
      {
        'title': 'Laptop Acer',
        'price': '15.000.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
      {
        'title': 'Samsung Phone',
        'price': '8.500.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
    ],
    'Clothes': [
      {
        'title': 'T-Shirt',
        'price': '350.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
      {
        'title': 'Jeans',
        'price': '600.000đ',
        'shop': 'shop name',
        'image': TImages.productImage1,
      },
    ],
  };

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

          // 🔍 SEARCH BAR
          SliverPadding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search in Store',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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

          // ⭐ BRAND GRID - DỮ LIỆU TỪ BRAND CONTROLLER
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final brand = brandCtrl.brands[index];

                    return TBrandCard(
                      showBorder: true,
                      brandName: brand['name'],
                      productCount: "", // API chưa có count
                      icon: brand['logo_url'] ?? TImages.clothIcon,
                      onTap: () async {
                        await brandCtrl.fetchProducts(brand['id']);

                        Get.to(() => BrandProducts(
                              brandName: brand['name'],
                              icon: brand['logo_url'] ?? TImages.clothIcon,
                              productCount:
                                  brandCtrl.productCount.value.toString(),
                            ));
                      },
                    );
                  },
                  childCount: brandCtrl.brands.length,
                ),
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

          // 🔥 CATEGORY SELECTOR
          CategorySection(
            categories: _categories,
            selectedIndex: _selectedCategoryIndex,
            onSelect: (index) => setState(() => _selectedCategoryIndex = index),
          ),

          // 🛍 PRODUCT GRID - STATIC DEMO
          SliverPadding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = _categories[_selectedCategoryIndex];
                  final products = _categoryProducts[category] ?? [];

                  if (index >= products.length) return const SizedBox();

                  final p = products[index];

                  return TProductCardVertical(
                    title: p['title'],
                    price: p['price'],
                    shop: p['shop'],
                    imageUrl: p['image'],
                  );
                },
                childCount: _categoryProducts[_categories[_selectedCategoryIndex]]?.length ?? 0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: TSizes.spaceBtwItems,
                crossAxisSpacing: TSizes.spaceBtwItems,
                mainAxisExtent: 280,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
