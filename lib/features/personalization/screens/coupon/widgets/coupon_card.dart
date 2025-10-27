// lib/features/personalization/screens/coupon/widgets/coupon_card.dart

import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TCouponCard extends StatelessWidget {
  const TCouponCard({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      backgroundColor: isDark ? TColors.dark : TColors.white,
      padding: const EdgeInsets.all(TSizes.md),
      child: Column(
        children: [
          /// -- Row with Coupon Details
          Row(
            children: [
              /// -- Coupon Title, Code, and Subtitle
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Save 50.00%', style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.primary)),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text('OFF50', style: Theme.of(context).textTheme.titleLarge!.apply(color: isDark ? TColors.white : TColors.darkerGrey)),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text('OFF50', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),

              /// -- Redeem Button
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: isDark ? TColors.white.withOpacity(0.5) : TColors.dark.withOpacity(0.5),
                    backgroundColor: isDark ? TColors.darkerGrey.withOpacity(0.2) : TColors.light,
                    side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: const Text('Redeem'),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Row with '0 Left' and Expiry Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 Left',
                style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.red),
              ),
              Text(
                'Valid until 12 Aug 2025',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}