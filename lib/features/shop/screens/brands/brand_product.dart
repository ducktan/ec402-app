import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/products/sortable/sortable_products.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Nike'),
        showBackArrow: true, // ✅ thêm dòng này
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TBrandCard(showBorder: true),
              const SizedBox(height: TSizes.spaceBtwSections),
              const TSortableProducts(),
            ],
          ),
        ),
      ),
    );
  }
}