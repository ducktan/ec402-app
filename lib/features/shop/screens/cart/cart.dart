import 'package:ec402_app/features/shop/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/shop/screens/checkout/checkout.dart';
import 'package:ec402_app/features/shop/screens/product_detail/product_detail_screen.dart';
import 'package:ec402_app/features/shop/screens/checkout/checkout.dart';

// utils
import 'package:ec402_app/utils/constants/image_strings.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final controller = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    // Fetch cart data every time the screen is initialized
    controller.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetCacheSize = (56 * devicePixelRatio).round();

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: TAppBar(
        title: Text("Giỏ hàng", style: theme.textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Obx(() {
        // Show an error message if there is one
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchCart(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        // Show a loader while the cart is loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show empty cart message
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Giỏ hàng của bạn đang trống',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        // Display cart items
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cartItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.cartItems[index];
            final product = item['product'] as Map<String, dynamic>? ?? {};
            final cartItemId = item['id'] as int? ?? 0;
            final quantity = item['quantity'] as int? ?? 0;

            return InkWell(
              onTap: () {
                final productId = product['id'] ?? product['product_id'] ?? 0;

                if (productId != 0) {
                  Get.to(() => ProductDetailScreen(product: product));
                } else {
                  Get.snackbar(
                    "Lỗi",
                    "Không tìm thấy ID sản phẩm",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),

              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: colorScheme.surface,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product['avatar'] ?? TImages.noImage,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['brand'] ?? 'No brand',
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product['title'] ?? 'No name',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    // Quantity buttons
                                    IconButton(
                                      icon: Icon(Icons.remove, size: 18),
                                      onPressed: () =>
                                          controller.updateCartItemQuantity(
                                            cartItemId,
                                            quantity - 1,
                                          ),
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      icon: Icon(Icons.add, size: 18),
                                      onPressed: () =>
                                          controller.updateCartItemQuantity(
                                            cartItemId,
                                            quantity + 1,
                                          ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${(product['price'] ?? 0 * quantity).toString()}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Delete button giữ nguyên
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          // Xóa sản phẩm
                          controller.deleteCartItem(cartItemId);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),

      // ===== Checkout Button =====
      bottomNavigationBar: Obx(
        () => controller.cartItems.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => CheckoutScreen(cartItems: controller.cartItems));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                      () => Text(
                        'Thanh toán \$${controller.totalPrice.value.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                          
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
