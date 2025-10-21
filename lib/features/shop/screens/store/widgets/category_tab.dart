import 'package:flutter/material.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// -- Brands
            TBrandShowcase(images: [TImages.productImage3, TImages.productImage2, TImages.productImage1]),
            TBrandShowcase(images: [TImages.productImage3, TImages.productImage2, TImages.productImage1]),
            const SizeBox(height: TSizes.spaceBtwItems),

            /// -- Products
            TSectionHeading(title: 'You might like', onPressed: () {}),
            const SizeBox(height: TSizes.spaceBtwItems),
            TGridLayout(itemCount: 4,itemBuilder:(_,index) => TProductCardVertical() )
          ],
        ), // Colum
      ),// Padding
  ],
}