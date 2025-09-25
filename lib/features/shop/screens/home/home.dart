import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/appbar/primary_header_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/saerch_container.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
