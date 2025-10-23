import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/products.card/cart_menu_icon.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 thêm cái này
import '../../../controllers/home_controller.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance; // 👈 khai báo controller

    return TAppBar(
      title: Obx(() => Column(   // 👈 dùng Obx để reactive
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good morning ☀️",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(color: TColors.grey),
              ),
              Text(
                controller.username.value.isNotEmpty
                    ? controller.username.value
                    : 'Guest',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .apply(color: TColors.white),
              ),
            ],
          )),
      actions: [TCartCounterIcon(onPressed: () {}, iconColor: TColors.white)],
    );
  }
}
