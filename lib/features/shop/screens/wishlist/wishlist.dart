import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shop/controllers/wishlist_controller.dart';
import '../../../shop/controllers/cart_controller.dart';

import '../../../shop/screens/product_detail/product_detail_screen.dart';
import '../../../../utils/constants/image_strings.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.put(WishlistController());
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist"), centerTitle: true),
      body: Obx(() {
        if (wishlistController.wishlistProducts.isEmpty) {
          return const Center(
            child: Text(
              "Your wishlist is empty",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final wishlist = wishlistController.wishlistProducts;

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: wishlist.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = wishlist[index];
            final productId = product['id'];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                isThreeLine: true,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.network(
                      product['image_url'] ?? TImages.noImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(TImages.noImage, fit: BoxFit.cover),
                    ),
                  ),
                ),
                title: Text(
                  product['name'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "Brand: ${product['brand_name'] ?? 'Unknown'}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    if (product['color'] != null || product['size'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '${product['color'] != null ? 'Color ${product['color']}' : ''}'
                          '${product['color'] != null && product['size'] != null ? '   ' : ''}'
                          '${product['size'] != null ? 'Size ${product['size']}' : ''}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () => cartController.addToCart(
                            productId: productId,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        Obx(() {
                          final isFav = wishlistController.isFavorite(
                            productId,
                          );
                          return IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              await wishlistController.toggleWishlist(
                                productId,
                              );

                              // Hiển thị snackbar thông báo
                              Get.snackbar(
                                isFav ? 'Removed' : 'Added',
                                isFav
                                    ? 'Product removed from your wishlist'
                                    : 'Product added to your wishlist',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black87,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(12),
                                duration: const Duration(seconds: 2),
                              );
                            },
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          );
                        }),
                        const Spacer(),
                        Text(
                          "\$${product['price'] ?? '0'}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => ProductDetailScreen(product: product));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
