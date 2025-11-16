import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/store/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/products/sortable/sortable_products.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({
    super.key,
    required this.brandName,
    required this.icon,
    required this.productCount,
  });

  final String brandName;
  final String? icon;
  final String productCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(brandName),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Hiển thị card thương hiệu ở đầu trang
              TBrandCard(
                showBorder: true,
                brandName: brandName,
                productCount: productCount,
                icon: icon,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Danh sách sản phẩm của thương hiệu
              const TSortableProducts(),
            ],
          ),
        ),
      ),
    );
  }
}