import 'package:ec402_app/features/shop/controllers/cart_controller.dart';
import 'package:ec402_app/features/shop/screens/cart/cart.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    required this.iconColor,
  });

  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    return Obx(
      () => Stack(
        children: [
          IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: Icon(Iconsax.shopping_bag, color: iconColor),
          ),
          if (controller.cartCount.value > 0)
            Positioned(
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: TColors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    controller.cartCount.value.toString(),
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: TColors.white,
                          fontSizeFactor: 0.8,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}