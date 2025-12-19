import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/store/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/features/shop/screens/brand/brand_product.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/brand_controller.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandCtrl = Get.put(BrandController());

    return Scaffold(
      appBar: const TAppBar(title: Text('Brands'), showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TSectionHeading(title: 'Brands', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            Obx(() {
              if (brandCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final brands = brandCtrl.brands;

              if (brands.isEmpty) {
                return const Center(child: Text("No brands found"));
              }

              return TGirdLayout(
                iTemCount: brands.length,
                mainAxisExtent: 80,
                itemBuilder: (context, index) {
                  final brand = brands[index];

                  return TBrandCard(
                    showBorder: true,
                    brandName: brand['name'] ?? "Unknown",
                    productCount: "${brand['productCount'].toString()} products" ?? "0", // FIXED
                    icon: brand['logo_url'] ?? TImages.clothIcon,
                    onTap: () async {
                      Get.to(() => BrandProducts(brandId: brand['id']));
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
