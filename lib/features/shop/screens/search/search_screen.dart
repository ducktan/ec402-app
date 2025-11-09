// path: lib/features/shop/screens/search/search_screen.dart

import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/features/shop/screens/filter/filter_screen.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Dữ liệu giả lập ---
    final brands = const [
      ('Acer', Icons.computer),
      ('IKEA', Icons.chair),
      ('Kenwood', Icons.kitchen),
      ('Samsung', Icons.phone_android),
      ('Adidas', Icons.style),
      ('ZARA', Icons.style),
      ('Puma', Icons.style),
      ('Apple', Icons.apple),
      ('Jordan', Icons.style),
      ('Nike', Icons.style),
      ('brand', Icons.error_outline),
    ];

    final categories = const [
      ('Sports', Icons.sports_basketball_outlined),
      ('Jewelery', Icons.diamond_outlined),
      ('Electronics', Icons.electrical_services_outlined),
      ('Clothes', Icons.checkroom_outlined),
      ('Animals', Icons.pets_outlined),
      ('demo', Icons.category_outlined),
      ('Flat', Icons.home_work_outlined),
      ('Furniture', Icons.table_restaurant_outlined),
    ];

    return Scaffold(
      // ===== SỬ DỤNG TAppBar =====
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Search'),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Thanh tìm kiếm + nút Filter =====
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                          ),
                          builder: (_) => const TFilterScreen(),
                        );
                      },
                      child: const Center(
                        child: Icon(
                          Icons.tune,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== Brands Section =====
            const TSectionHeading(title: 'Brands', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            GridView.builder(
              itemCount: brands.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (_, index) {
                final (name, icon) = brands[index];
                return GestureDetector(
                  onTap: () {
                    print('Tapped on Brand: $name');
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Icon(icon, color: Colors.black54, size: 30),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== Categories Section =====
            const TSectionHeading(title: 'Categories', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),
            ListView.builder(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final (name, icon) = categories[index];
                return ListTile(
                  leading: Icon(icon, color: Colors.black),
                  title: Text(name),
                  onTap: () {
                    print('Tapped on Category: $name');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
