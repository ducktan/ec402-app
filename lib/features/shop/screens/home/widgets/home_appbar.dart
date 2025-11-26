import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/products.card/cart_menu_icon.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../cart/cart.dart';
import 'package:ec402_app/features/personalization/screens/notification/notification.dart'; // 👈 import NotificationScreen
import 'package:iconsax/iconsax.dart'; // 👈 import iconsax package

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance; // 👈 khai báo controller
    final theme = Theme.of(context);

    return TAppBar(
      title: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good morning ☀️",
              style: theme.textTheme.labelMedium,
            ),
            Text(
              controller.username.value.isNotEmpty
                  ? controller.username.value
                  : 'Guest',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      actions: [
        // 👈 Icon thông báo
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          },
          icon: Icon(
            Iconsax.notification,
            color: theme.iconTheme.color,
          ),
        ),
        // 👈 Icon giỏ hàng
        TCartCounterIcon(
          iconColor: theme.iconTheme.color ?? TColors.white,
        ),
      ],
    );
  }
}