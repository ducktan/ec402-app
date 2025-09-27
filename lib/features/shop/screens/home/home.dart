import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/appbar/primary_header_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/home_categories.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  TSearchContainer(text: 'Search in Store'),
                  SizedBox(height: TSizes.spaceBtwSections),

                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: TColors.white,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        THomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
