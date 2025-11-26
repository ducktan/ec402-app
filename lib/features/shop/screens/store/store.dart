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

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  static const List<Map<String, dynamic>> _brands = [
    {'name': 'Acer', 'products': '15 products', 'icon': TImages.shoeIcon},
    {'name': 'IKEA', 'products': '25 products', 'icon': TImages.shoeIcon},
    {'name': 'Kenwood', 'products': '8 products', 'icon': TImages.shoeIcon},
    {'name': 'Samsung', 'products': '30 products', 'icon': TImages.shoeIcon},
  ];

  final List<String> _categories = [
    'Sports',
    'Jewelery',
    'Electronics',
    'Clothes',
    'Animals',
    'Demo',
    'Flat',
    'Furniture',
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
              iconColor: TColors.black,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SEARCH + TITLE
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
                      borderSide: const BorderSide(color: Colors.grey),
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

          // GRID BRANDS
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace,
            ),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final brand = _brands[index];
                return TBrandCard(
                  showBorder: true,
                  brandName: brand['name']!,
                  productCount: brand['products']!,
                  icon: brand['icon'],
                  onTap: () => Get.to(
                    () => BrandProducts(
                      brandName: brand['name']!,
                      icon: brand['icon'],
                      productCount: brand['products']!,
                    ),
                  ),
                );
              }, childCount: _brands.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 80,
                crossAxisSpacing: TSizes.spaceBtwItems,
                mainAxisSpacing: TSizes.spaceBtwItems,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: TSizes.spaceBtwSections),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: TSizes.spaceBtwSections),
          ),

          // ✅ CATEGORY SELECTOR
          CategorySection(
            categories: _categories,
            selectedIndex: _selectedCategoryIndex,
            onSelect: (index) {
              setState(() => _selectedCategoryIndex = index);
              print('Tapped on Category: ${_categories[index]}');
            },
          ),

          // ✅ PRODUCT GRID THEO CATEGORY
          SliverPadding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final categoryName = _categories[_selectedCategoryIndex];
                  final products = _categoryProducts[categoryName] ?? [];

                  if (index >= products.length) return const SizedBox();
                  final product = products[index];

                  return TProductCardVertical(
                    title: product['title']!,
                    price: product['price']!,
                    shop: product['shop'],
                    imageUrl: product['image']!,
                  );
                },
                childCount:
                    _categoryProducts[_categories[_selectedCategoryIndex]]
                        ?.length ??
                    0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: TSizes.spaceBtwItems,
                crossAxisSpacing: TSizes.spaceBtwItems,
                mainAxisExtent: 280, // chiều cao mỗi card
              ),
            ),
          ),
        ],
      ),
    );
  }
}
