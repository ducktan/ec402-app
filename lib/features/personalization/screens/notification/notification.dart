import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = THelperFunctions.isDarkMode(context);

    // Fake notifications
    final notifications = [
      {
        'title': 'Order Placed',
        'message': 'Your order #123456 has been placed successfully.',
        'isRead': false,
        'time': '2h ago',
      },
      {
        'title': 'Discount Coupon',
        'message': 'You received a new coupon OFF50!',
        'isRead': true,
        'time': '1d ago',
      },
      {
        'title': 'Order Shipped',
        'message': 'Your order #123456 is on the way.',
        'isRead': false,
        'time': '3d ago',
      },
    ];

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Notifications', style: theme.textTheme.headlineSmall),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
        itemBuilder: (_, index) {
          final notification = notifications[index];
          final isRead = notification['isRead'] as bool;

          // Màu nền dựa vào trạng thái read/unread và theme
          final bgColor = isRead
              ? theme.cardColor
              : theme.colorScheme.primary.withOpacity(0.1);

          final iconColor = isRead
              ? theme.iconTheme.color?.withOpacity(0.6)
              : theme.colorScheme.primary;

          return Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(TSizes.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Iconsax.notification,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'] as String,
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'] as String,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['time'] as String,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: theme.textTheme.bodySmall!.color?.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
