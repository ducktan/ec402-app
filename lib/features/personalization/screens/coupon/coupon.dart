// lib/features/personalization/screens/coupon/coupon.dart

import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/personalization/screens/coupon/widgets/coupon_card.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      /// -- AppBar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Coupons',
          style: theme.textTheme.headlineSmall,
        ),
      ),

      /// -- Body
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, __) =>
              const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) => const TCouponCard(),
        ),
      ),
    );
  }
}
