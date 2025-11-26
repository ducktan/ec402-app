import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/features/shop/screens/filter/filter_screen.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
// Import Controller
import '../../controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());

    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Search')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== THANH TÌM KIẾM =====
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchTextController,
                    onSubmitted: (value) => controller.search(query: value),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                // Nút Filter
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (_) => const TFilterScreen(),
                      );
                    },
                    icon: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== KẾT QUẢ TÌM KIẾM (DẠNG LƯỚI 2 CỘT - HÌNH 1) =====
            // ===== KẾT QUẢ TÌM KIẾM =====
            Obx(() {
              if (controller.searchResults.isEmpty) {
                return const SizedBox.shrink(); // Không hiện gì khi chưa có kết quả
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TSectionHeading(
                    title: 'Search Results',
                    showActionButton: false,
                  ),
                  const SizedBox(height: 10),

                  // ⬇⬇⬇ THAY THẾ GRIDVIEW BẰNG TGridLayout + TProductCardVertical ⬇⬇⬇
                  TGirdLayout(
                    iTemCount: controller.searchResults.length,
                    childAspectRatio: 0.55,
                    itemBuilder: (_, index) {
                      final product = controller.searchResults[index];

                      return TProductCardVertical(
                        title: product['name'] ?? 'Unknown',
                        price: "${product['price']} VNĐ",
                        shop: product['brand'] ?? "Unknown Store",
                        imageUrl: product['image_url'] ?? "",
                        onTap: () {
                          print("→ Tap: ${product['name']}");
                          // Get.to(() => ProductDetailScreen(product: product));
                        },
                      );
                    },
                  ),

                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              );
            }),

            // ===== BRANDS =====
            const TSectionHeading(title: 'Brands', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(() {
              if (controller.isLoading.value && controller.brands.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.brands.isEmpty) {
                return const Text("No brands found");
              }

              return GridView.builder(
                itemCount: controller.brands.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (_, index) {
                  final brand = controller.brands[index];
                  return Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child:
                            (brand['logo_url'] != null &&
                                brand['logo_url'] != '')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  brand['logo_url'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.error),
                                ),
                              )
                            : const Icon(Icons.verified, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        brand['name'] ?? 'Brand',
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== CATEGORIES =====
            const TSectionHeading(title: 'Categories', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(() {
              if (controller.categories.isEmpty) return const SizedBox();

              return ListView.builder(
                itemCount: controller.categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  final cat = controller.categories[index];
                  return ListTile(
                    leading: const Icon(Icons.category, color: Colors.black),
                    title: Text(cat['name'] ?? 'Category'),
                    onTap: () {
                      controller.search(query: cat['name']);
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
