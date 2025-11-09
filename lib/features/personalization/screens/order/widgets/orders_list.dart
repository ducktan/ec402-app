import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/features/personalization/screens/order/order_detail.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (_, index) => TRoundedContainer(
        showBorder: true,
        padding: const EdgeInsets.all(TSizes.md),
        backgroundColor: colorScheme.surface,
        borderColor: colorScheme.outlineVariant.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Row 1: Trạng thái + Ngày
            Row(
              children: [
                Icon(Iconsax.ship, color: colorScheme.primary),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processing',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '12 Jan, 2024',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.to(() => const OrderDetailScreen()),
                  icon: Icon(Iconsax.arrow_right_34,
                      size: TSizes.iconSm, color: colorScheme.onSurface),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Row 2: Mã đơn + Ngày giao
            Row(
              children: [
                /// Mã đơn
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Iconsax.tag, color: colorScheme.primary),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order',
                              style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant)),
                          Text('#123456',
                              style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface)),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Ngày giao
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Iconsax.calendar, color: colorScheme.primary),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Shipping Date',
                              style: textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant)),
                          Text('03 Feb, 2024',
                              style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
