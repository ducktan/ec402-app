import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/common/widgets/images/t_circular_image.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text('Order Details', style: theme.textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------- Order Summary --------
            _SectionHeader(icon: Iconsax.bag_2, title: 'Order Summary', context: context),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            TRoundedContainer(
              showBorder: true,
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outlineVariant,
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderRow('Order ID:', '[#489a0]', context),
                  _buildOrderRow('Placed on:', '17/10/2025', context),
                  _buildOrderRow('Grand Total:', '\$122.6', context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Status:', style: theme.textTheme.bodyMedium),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Text(
                          'Pending',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// -------- Items --------
            _SectionHeader(icon: Iconsax.shopping_cart, title: 'Items', context: context),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            TRoundedContainer(
              showBorder: true,
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outlineVariant,
              padding: const EdgeInsets.all(TSizes.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TCircularImage(
                    image: TImages.productImage1,
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Green Nike sports shoe',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('\$122.6', style: theme.textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('Unit Price: \$134.0',
                                style: theme.textTheme.labelMedium),
                            const SizedBox(width: 12),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Quantity:',
                                    style: theme.textTheme.labelMedium),
                                const SizedBox(width: 4),
                                Text('1', style: theme.textTheme.labelMedium),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Iconsax.star, size: 16),
                            label: const Text('Review Product'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              textStyle: theme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// -------- Shipping Address --------
            _SectionHeader(
                icon: Iconsax.location, title: 'Shipping Address', context: context),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            TRoundedContainer(
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outlineVariant,
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _AddressRow(label: 'Name:', value: 'Oliva Nguyen'),
                  _AddressRow(label: 'Email:', value: 'thuytienn24th@gmail.com'),
                  _AddressRow(label: 'Address:', value: '2, tp, e 22222, viet nam'),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// -------- Billing Address --------
            _SectionHeader(icon: Iconsax.home, title: 'Billing Address', context: context),
            TRoundedContainer(
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outlineVariant,
              padding: const EdgeInsets.all(TSizes.md),
              child: Text('Billing Address is Same as Shipping Address',
                  style: theme.textTheme.bodyMedium),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// -------- Payment Details --------
            _SectionHeader(
                icon: Iconsax.wallet_2, title: 'Payment Details', context: context),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            TRoundedContainer(
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outlineVariant,
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                children: [
                  _buildOrderRow('Subtotal (1 items):', '\$122.6', context),
                  _buildOrderRow('Delivery Fee:', '\$0.0', context),
                  _buildOrderRow('Tax Amount:', '\$0.0', context),
                  const Divider(),
                  _buildOrderRow('Total:', '\$122.6', context, bold: true),
                  _buildOrderRow('Payment Method:', 'Cash on Delivery', context),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// -------- Delivery Status --------
            _SectionHeader(icon: Iconsax.truck, title: 'Delivery Status', context: context),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            TRoundedContainer(
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outlineVariant,
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('[#6d291]', style: theme.textTheme.labelMedium),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  _DeliveryStep(
                      icon: Iconsax.timer,
                      title: 'Order Placed',
                      status: 'Pending',
                      active: true),
                  const _DeliveryStep(
                      icon: Iconsax.refresh,
                      title: 'Processing',
                      status: 'In Progress'),
                  const _DeliveryStep(
                      icon: Iconsax.truck, title: 'Shipped', status: 'On the Way'),
                  const _DeliveryStep(
                      icon: Iconsax.home, title: 'Delivered', status: 'Arrived'),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Cancel Order',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(String label, String value, BuildContext context,
      {bool bold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: bold
                ? theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String label;
  final String value;
  const _AddressRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(width: 6),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _DeliveryStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final bool active;

  const _DeliveryStep({
    required this.icon,
    required this.title,
    required this.status,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = active ? colorScheme.primary : colorScheme.outline;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(status,
                    style: theme.textTheme.labelMedium?.copyWith(color: color)),
              ],
            ),
          ),
          if (active)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary, width: 2),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: colorScheme.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final BuildContext context;

  const _SectionHeader({required this.icon, required this.title, required this.context});

  @override
  Widget build(BuildContext _) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
