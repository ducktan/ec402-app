// checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import './widget/coupon_section.dart';
import './widget/order_summary.dart';
import './widget/payment_method_section.dart';
import './widget/product_list.dart';
import './widget/shipping_address_section.dart';
import './order_sucess_screen.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===== Sanitize cartItems: parse price & quantity =====
    final List<Map<String, dynamic>> sanitizedCart = cartItems.map((item) {
      final product = item['product'] as Map<String, dynamic>? ?? {};

      // Parse price
      double price;
      if (product['price'] is String) {
        price = double.tryParse(product['price']) ?? 0.0;
      } else if (product['price'] is num) {
        price = (product['price'] as num).toDouble();
      } else {
        price = 0.0;
      }

      // Parse quantity
      int quantity;
      if (item['quantity'] is String) {
        quantity = int.tryParse(item['quantity']) ?? 0;
      } else if (item['quantity'] is int) {
        quantity = item['quantity'] as int;
      } else {
        quantity = 0;
      }

      return {
        'id': item['id'],
        'quantity': quantity,
        'product': {
          ...product,
          'price': price, // chắc chắn là double
        },
      };
    }).toList();

    // ===== Calculate subtotal, total =====
    final subtotal = sanitizedCart.fold<double>(0.0, (sum, item) {
      final product = item['product'] as Map<String, dynamic>;
      final price = product['price'] as double;
      final quantity = item['quantity'] as int;
      return sum + price * quantity;
    });

    const shippingFee = 0.0;
    const taxFee = 0.0;
    final total = subtotal + shippingFee + taxFee;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: TAppBar(
        title: Text(
          'Checkout',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        showBackArrow: true,
        actions: [
          Icon(Icons.notifications_none_rounded, color: colorScheme.onBackground),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductList(cartItems: sanitizedCart),
            const SizedBox(height: TSizes.spaceBtwSections),
            CouponSection(),
            const SizedBox(height: TSizes.spaceBtwSections),
            OrderSummary(
              subtotal: subtotal,
              shippingFee: shippingFee,
              taxFee: taxFee,
              total: total,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            PaymentMethodSection(),
            const SizedBox(height: TSizes.spaceBtwSections),
            ShippingAddressSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
            );
          },
          child: Text(
            "Checkout \$${total.toStringAsFixed(2)}",
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
