// path: lib/features/shop/screens/filter/filter_screen.dart

import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/features/shop/screens/filter/widgets/sort_by_dropdown.dart';
import 'package:ec402_app/features/shop/screens/filter/widgets/category_filter_item.dart';

class TFilterScreen extends StatefulWidget {
  const TFilterScreen({super.key});

  @override
  State<TFilterScreen> createState() => _TFilterScreenState();
}

class _TFilterScreenState extends State<TFilterScreen> {
  final Map<String, List<String>> _categories = {
    'Sports': ['Sports Equipments', 'Sport Shoes', 'Track suits'],
    'Jewelery': ['Rings', 'Necklaces', 'Bracelets'],
    'Electronics': ['Smartphones', 'Laptops', 'Headphones'],
    'Clothes': ['T-Shirts', 'Jeans', 'Jackets'],
    'Animals': ['Dog Food', 'Cat Toys', 'Fish Tanks'],
    'Furniture': ['Chairs', 'Tables', 'Sofas'],
  };

  String? _selectedSubCategory;
  String? _priceMin;
  String? _priceMax;

  void _handleSubCategorySelection(String? selectedValue) {
    setState(() {
      _selectedSubCategory = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // --- BODY (SCROLLABLE) ---
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SORT BY ---
                  const Text('Sort by', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  const TSortByDropdown(),

                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // --- PRICE RANGE ---
                  const Text('Price Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Row(
                    children: [
                      // --- MIN ---
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Min',
                            prefixText: '₫ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (value) => _priceMin = value,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // --- MAX ---
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Max',
                            prefixText: '₫ ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (value) => _priceMax = value,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // --- CATEGORY ---
                  const Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final categoryName = _categories.keys.elementAt(index);
                      final subCategories = _categories[categoryName]!;
                      return TCategoryFilterItem(
                        categoryName: categoryName,
                        subCategories: subCategories,
                        selectedSubCategory: _selectedSubCategory,
                        onSubCategorySelected: _handleSubCategorySelection,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- APPLY BUTTON ---
          const SizedBox(height: TSizes.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Xử lý logic apply filter
                Navigator.pop(context, {
                  'category': _selectedSubCategory,
                  'priceMin': _priceMin,
                  'priceMax': _priceMax,
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF6C4EFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply Filter'),
            ),
          ),
        ],
      ),
    );
  }
}
