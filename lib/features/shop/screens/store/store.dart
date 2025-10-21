import 'dart:convert';

import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/common/widgets/appbar/tabbar.dart';
import 'package:ec402_app/common/widgets/layouts/grid_layout.dart';
import 'package:ec402_app/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:ec402_app/features/shop/screens/store/widgets/category_tab.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'sections/header_heading.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child:
      Scaffold(
    /// tabs
    bottom: TTabBar(
        tabs: [
            Tab(child: Text('Sport')),
            Tab(child: Text('Furniture')),
            Tab(child: Text('Electronics')),
            Tab(child: Text('Clothes')),
            Tab(child: Text('Cosmetics')),
          ]
        ]),
        body: TabBarView(
          children: [
            TCategoryTab(),
            TCategoryTab(),
            TCategoryTab(),
            TCategoryTab(),
            TCategoryTab(),
          ],
        ),
     ),
    ),
  }
}

class TBrandShowCase extends StatelessWidget {
  const TBrandShowCase({
    super.key,
    required this.images,
  });
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      borderColor: TColors.darkGrey,
      backgrounColor: Colors.transparent,
      padding:const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Column(
        children: [
          ///brand with product count
          const TBrandCard(showBorder:false),
          ///brand top 3 product images
          Row(
              children: images.map((image) => brandTopProductImageWidget(image, context)).tolist())
            )
          ],
      ),
    );
  }
  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: TRoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only(right: TSizes.sm),
        backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkerGrey : TColors.light,
        child: Image(fit: BoxFit.contain, image: AssetImage(images)),
      ), // TRoundedContainer
    ); // Expanded
  }
}