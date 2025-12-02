import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/wishlist_controller.dart';
import 'package:iconsax/iconsax.dart';

class ProductBottomBar extends StatelessWidget {
  final int productId;
  final WishlistController wishlistController;

  const ProductBottomBar({
    super.key,
    required this.productId,
    required this.wishlistController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(() {
            final isFav = wishlistController.isFavorite(productId);
            return IconButton(
              onPressed: () async {
                await wishlistController.toggleWishlist(productId);

                // Hiện thông báo
                if (wishlistController.isFavorite(productId)) {
                  Get.snackbar(
                    "Wishlist",
                    "Đã thêm vào wishlist",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    colorText: Colors.black,
                  );
                } else {
                  Get.snackbar(
                    "Wishlist",
                    "Đã xóa khỏi wishlist",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    colorText: Colors.black,
                  );
                }
              },
              icon: Icon(
                Iconsax.heart5,
                color: isFav ? Colors.red : Colors.grey,
              ),
            );
          }),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: thêm vào giỏ
              },
              icon: const Icon(Iconsax.shopping_cart, size: 18),
              label: const Text("Thêm vào giỏ hàng"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
