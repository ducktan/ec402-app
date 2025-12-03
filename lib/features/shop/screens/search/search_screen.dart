import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:ec402_app/features/shop/screens/filter/filter_screen.dart';
import '../../controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());

    return Scaffold(
      appBar: const TAppBar(title: Text('Search'), showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== 1. THANH TÌM KIẾM =====
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchTextController,
                    onChanged: (value) => controller.onSearchChanged(value),
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Get.to(() => const TFilterScreen()),
                    icon: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== 2. KHU VỰC HIỂN THỊ CHÍNH (QUAN TRỌNG) =====
            Obx(() {
              // TRƯỜNG HỢP A: Đang gõ tìm kiếm
              if (controller.isSearching.value) {
                // 1. Đang tải dữ liệu
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Không tìm thấy kết quả nào
                if (controller.searchResults.isEmpty) {
                  return const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Không tìm thấy sản phẩm nào phù hợp."),
                      ],
                    ),
                  );
                }

                // 3. Có kết quả -> Hiển thị danh sách
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TSectionHeading(
                          title: 'Kết quả tìm kiếm',
                          showActionButton: false,
                        ),
                        Text(
                          "${controller.searchResults.length} sản phẩm",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    TGirdLayout(
                      iTemCount: controller.searchResults.length,
                      childAspectRatio: 0.55,
                      itemBuilder: (_, index) {
                        final product = controller.searchResults[index];
                        return TProductCardVertical(
                          title: product['name'] ?? '',
                          price: "${product['price'] ?? 0}",
                          shop: product['brand_name'] ?? '',
                          imageUrl: product['image_url'] ?? '',
                        );
                      },
                    ),
                  ],
                );
              }

              // TRƯỜNG HỢP B: Chưa tìm kiếm -> Hiện Brands & Categories (Màn hình mặc định)
              return Column(
                children: [
                  // --- BRANDS ---
                  const TSectionHeading(
                    title: 'Brands',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  if (controller.brands.isEmpty)
                    const Text("No brands found")
                  else
                    GridView.builder(
                      itemCount: controller.brands.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              child: (brand['logo_url'] != null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        brand['logo_url'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) =>
                                            const Icon(Icons.broken_image),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.verified,
                                      color: Colors.blue,
                                    ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              brand['name'] ?? '',
                              style: Theme.of(context).textTheme.labelSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  // --- CATEGORIES ---
                  const TSectionHeading(
                    title: 'Categories',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  if (controller.categories.isEmpty)
                    const Text("No categories found")
                  else
                    ListView.builder(
                      itemCount: controller.categories.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        final cat = controller.categories[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.category,
                            color: Colors.black,
                          ),
                          title: Text(cat['name'] ?? 'Category'),
                          onTap: () {
                            // Khi bấm vào Category -> Tự động điền vào ô search
                            controller.searchTextController.text = cat['name'];
                            controller.onSearchChanged(cat['name']);
                          },
                        );
                      },
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}