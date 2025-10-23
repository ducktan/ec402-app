// lib/features/personalization/screens/coupon/coupon.dart

import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/personalization/screens/coupon/widgets/coupon_card.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      /// -- Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Coupon', style: Theme.of(context).textTheme.headlineSmall),
      ),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// -- List of Coupons
              TCouponCard(isDark: dark),
              const SizedBox(height: TSizes.spaceBtwItems),
              TCouponCard(isDark: dark), // Bạn có thể thay đổi dữ liệu ở đây
            ],
          ),
        ),
      ),
    );
  }
}