import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
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
            Obx(() {
              if (controller.searchResults.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TSectionHeading(
                      title: 'Search Results',
                      showActionButton: false,
                    ),
                    const SizedBox(height: 10),

                    // ✅ THAY LISTVIEW BẰNG GRIDVIEW
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.searchResults.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 Cột
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio:
                                0.75, // Tỷ lệ chiều cao/rộng của thẻ
                          ),
                      itemBuilder: (_, index) {
                        final product = controller.searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            // Xử lý khi bấm vào sản phẩm (chuyển sang chi tiết)
                            print("Bấm vào: ${product['name']}");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Hình ảnh & Nút tim (Stack)
                                Expanded(
                                  child: Stack(
                                    children: [
                                      // Hình nền xám / Ảnh sản phẩm
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .grey
                                              .shade100, // Nền xám giống hình mẫu
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          child: (product['image_url'] != null)
                                              ? Image.network(
                                                  product['image_url'],
                                                  fit: BoxFit.cover,
                                                )
                                              : const Center(
                                                  child: Icon(
                                                    Icons.image,
                                                    color: Colors.grey,
                                                    size: 40,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      // Nút Tim (Góc phải)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 2. Thông tin sản phẩm (Tên & Giá)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] ?? 'No Name',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${product['price']} VNĐ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.orange),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                );
              }
              return const SizedBox.shrink();
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
