// widgets/coupon_section.dart
import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class CouponSection extends StatelessWidget {
  const CouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Apply Coupon/Vouchers', style: theme.bodyMedium),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurfaceVariant),
            onTap: () {
              // TODO: Navigate to coupon screen
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Points: 0', style: theme.bodySmall),
              Switch(
                value: false,
                onChanged: (val) {},
                activeColor: colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
