import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/images/t_rounded_image.dart';
import 'order_sucess_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> cartItem; // Nhận dữ liệu từ trang Cart

  const CheckoutScreen({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final double subtotal = cartItem['price'];
    const double shippingFee = 0;
    const double taxFee = 0;
    final double total = subtotal + shippingFee + taxFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const TAppBar(
        title: Text('CheckOut'),
        showBackArrow: true,
        actions: [
          Icon(Icons.notifications_none_rounded, color: Colors.black),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Product info
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
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 🔹 Apply Coupon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Apply Coupon/Vouchers'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: Colors.grey),
                    onTap: () {
                      // TODO: Navigate to coupon screen
                    },
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Available Points: 0'),
                      Switch(
                        value: false,
                        onChanged: (val) {},
                        activeColor: TColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 🔹 Order summary
            _buildOrderSummary(subtotal, shippingFee, taxFee, total),

            const SizedBox(height: TSizes.spaceBtwSections),

            /// 🔹 Payment method
            _buildSectionTitle("Payment Method", trailing: "Change"),
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.payments_rounded, color: TColors.primary),
                SizedBox(width: 8),
                Text("Cash On Delivery",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// 🔹 Shipping address
            _buildSectionTitle("Shipping Address", trailing: "Change"),
            const SizedBox(height: 8),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on_outlined, color: Colors.grey),
              title: Text("Nguyễn Văn A"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text("0909123456"),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.home_outlined, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                            "123 Lê Duẩn, Quận 1, TP.HCM, Việt Nam"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              children: [
                Checkbox(value: true, onChanged: (_) {}),
                const Text("Billing Address is Same as Shipping"),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      /// 🔹 Checkout button bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        decoration: BoxDecoration(
          color: Colors.white,
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
            backgroundColor: TColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
            );
          },
          child: Text("Checkout \$${total.toStringAsFixed(2)}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  // 🔸 Widget: section title
  Widget _buildSectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        if (trailing != null)
          Text(trailing, style: const TextStyle(color: TColors.primary)),
      ],
    );
  }

  // 🔸 Widget: order summary box
  Widget _buildOrderSummary(
      double subtotal, double shippingFee, double taxFee, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Subtotal", subtotal),
          _buildSummaryRow("Shipping Fee", shippingFee),
          _buildSummaryRow("Tax Fee", taxFee),
          const Divider(),
          _buildSummaryRow("Order Total", total, bold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
