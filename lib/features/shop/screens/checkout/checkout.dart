import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/images/t_rounded_image.dart';
import 'order_sucess_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> cartItem; // Nhận dữ liệu từ trang Cart

  const CheckoutScreen({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double subtotal = cartItem['price'];
    const double shippingFee = 0;
    const double taxFee = 0;
    final double total = subtotal + shippingFee + taxFee;

    return Scaffold(
      backgroundColor: colorScheme.background,

      /// AppBar
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

      /// Body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🛍 Product Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TRoundedImage(
                  imageUrl: cartItem['image'],
                  width: 60,
                  height: 60,
                  borderRadius: 12,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${cartItem['title']} (${cartItem['variant'] ?? ''})",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 🎟 Coupon
            Container(
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
                    title: Text('Apply Coupon/Vouchers',
                        style: theme.textTheme.bodyMedium),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: colorScheme.onSurfaceVariant),
                    onTap: () {
                      // TODO: Navigate to coupon screen
                    },
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Available Points: 0',
                          style: theme.textTheme.bodySmall),
                      Switch(
                        value: false,
                        onChanged: (val) {},
                        activeColor: colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 💰 Order Summary
            _buildOrderSummary(context, subtotal, shippingFee, taxFee, total),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// 💳 Payment Method
            _buildSectionTitle(context, "Payment Method", trailing: "Change"),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.payments_rounded, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text("Cash On Delivery",
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onBackground)),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 📦 Shipping Address
            _buildSectionTitle(context, "Shipping Address", trailing: "Change"),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on_outlined,
                  color: colorScheme.onSurfaceVariant),
              title: Text("Nguyễn Văn A",
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onBackground)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16,
                          color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text("0909123456", style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.home_outlined,
                          size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "123 Lê Duẩn, Quận 1, TP.HCM, Việt Nam",
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (_) {},
                  activeColor: colorScheme.primary,
                ),
                Expanded(
                  child: Text(
                    "Billing Address is same as Shipping",
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      /// 🔘 Checkout button
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
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrderSuccessScreen(),
              ),
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

  // 🔹 Section title
  Widget _buildSectionTitle(BuildContext context, String title,
      {String? trailing}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onBackground)),
        if (trailing != null)
          Text(trailing,
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.primary)),
      ],
    );
  }

  // 🔹 Order summary
  Widget _buildOrderSummary(BuildContext context, double subtotal,
      double shippingFee, double taxFee, double total) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildSummaryRow(context, "Subtotal", subtotal),
          _buildSummaryRow(context, "Shipping Fee", shippingFee),
          _buildSummaryRow(context, "Tax Fee", taxFee),
          const Divider(),
          _buildSummaryRow(context, "Order Total", total, bold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double value,
      {bool bold = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              )),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onBackground,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
