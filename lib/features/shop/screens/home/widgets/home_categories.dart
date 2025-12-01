import 'package:ec402_app/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:ec402_app/features/shop/screens/category/category_products_screen.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/category_controller.dart';

class THomeCategories extends StatelessWidget {
  THomeCategories({super.key});

  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Obx(() {
        if (categoryController.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = categoryController.categories;

        if (categories.isEmpty) {
          return const Center(child: Text("No categories found"));
        }

        return ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final category = categories[index];

            return TVerticalImageText(
              // Nếu image_url trống, sẽ dùng iconData
              image: (category['image_url'] ?? "").isNotEmpty ? category['image_url'] : null,
              iconData: Iconsax.category, // <--- icon từ Iconsax
              title: category['name'] ?? "Unknown",
              onTap: () async {
                final categoryId = category['id'];
                await categoryController.selectCategory(categoryId);

                Get.to(() => CategoryProductsScreen(
                      categoryName: category['name'] ?? "Category",
                      products: List<Map<String, dynamic>>.from(categoryController.products),
                    ));
              },
            );
          },
        );
      }),
    );
  }
}
