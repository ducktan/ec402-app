import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/store/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/layouts/gird_layout.dart';
import 'package:ec402_app/common/widgets/products/sortable/sortable_products.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/features/shop/screens/brand/brand_product.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Dữ liệu mẫu — bạn có thể thay bằng danh sách lấy từ DB hoặc API
    final List<Map<String, String>> brands = [
      {
        'name': 'Nike',
        'products': '25',
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg'
      },
      {
        'name': 'Adidas',
        'products': '18',
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg'
      },
      {
        'name': 'Puma',
        'products': '12',
        'icon':
            'https://upload.wikimedia.org/wikipedia/en/f/fd/Puma_logo.svg'
      },
      {
        'name': 'Converse',
        'products': '10',
        'icon':
            'https://upload.wikimedia.org/wikipedia/commons/4/48/Converse_logo.svg'
      },
    ];

    return Scaffold(
      appBar: const TAppBar(title: Text('Brand'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Brands', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Lưới thương hiệu
              TGirdLayout(
                iTemCount: brands.length,
                mainAxisExtent: 80,
                itemBuilder: (context, index) {
                  final brand = brands[index];
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}