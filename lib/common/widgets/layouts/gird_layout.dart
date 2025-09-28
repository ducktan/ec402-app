import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TGirdLayout extends StatelessWidget {
  const TGirdLayout({
    super.key,
    required this.iTemCount,
    this.mainAxisExtent = 288,
    required this.itemBuilder,
  });
  final int iTemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: iTemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: TSizes.spaceBtwItems,
        crossAxisSpacing: TSizes.spaceBtwItems,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
