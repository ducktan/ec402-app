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
import 'package:get/get.dart';
//controller 
import 'package:ec402_app/features/personalization/controllers/address_controller.dart';
// Payment
import 'package:ec402_app/services/stripe_service.dart';
import 'package:ec402_app/services/payment_service.dart';

// api
import 'package:ec402_app/services/order_api.dart';
// get token
import 'package:ec402_app/utils/helpers/user_session.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double orderTotal;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.orderTotal,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentMethod = "direct"; // mặc định COD
  Map<String, dynamic>? selectedVoucher;
  double finalTotal = 0;

  final AddressController addressCtrl = Get.isRegistered<AddressController>() ? Get.find<AddressController>() : Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // === IMPORTANT: dùng widget.cartItems thay vì cartItems ===
    final List<Map<String, dynamic>> sanitizedCart = widget.cartItems.map((
      item,
    ) {
      final product = item['product'] as Map<String, dynamic>? ?? {};

      double price;
      if (product['price'] is String) {
        price = double.tryParse(product['price']) ?? 0.0;
      } else if (product['price'] is num) {
        price = (product['price'] as num).toDouble();
      } else {
        price = 0.0;
      }

      int quantity;
      if (item['quantity'] is String) {
        quantity = int.tryParse(item['quantity']) ?? 0;
      } else if (item['quantity'] is int) {
        quantity = item['quantity'];
      } else {
        quantity = 0;
      }

      return {
        'id': item['id'],
        'quantity': quantity,
        'product': {...product, 'price': price},
      };
    }).toList();

    final subtotal = sanitizedCart.fold<double>(0.0, (sum, item) {
      final product = item['product'] as Map<String, dynamic>;
      final price = product['price'] as double;
      final quantity = item['quantity'] as int;
      return sum + price * quantity;
    });

    const shippingFee = 20.0;
    const taxFee = 0.0;
    final total = subtotal + shippingFee + taxFee;

    finalTotal = selectedVoucher != null
        ? selectedVoucher!['final_total']
        : total;

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
          Icon(
            Icons.notifications_none_rounded,
            color: colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductList(cartItems: sanitizedCart),
            const SizedBox(height: 16),
            CouponSection(
              orderTotal: subtotal.toDouble(),
              selectedVoucher: selectedVoucher,
              onVoucherApplied: (voucherData) {
                setState(() {
                  selectedVoucher = voucherData;
                });
              },
            ),
            const SizedBox(height: 16),
            OrderSummary(
              subtotal: subtotal,
              shippingFee: shippingFee,
              taxFee: taxFee,
              total: total,
              voucherDiscount: selectedVoucher != null
                  ? selectedVoucher!['discount_amount']
                  : 0,
              finalTotal: finalTotal,
            ),
            const SizedBox(height: 16),

            PaymentMethodSection(
              selected: paymentMethod,
              onSelect: (method) {
                setState(() {
                  paymentMethod = method;
                });
              },
            ),

            const SizedBox(height: 16),
            ShippingAddressSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
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
          onPressed: () async {
            final token = await UserSession.getToken();

            // Lấy địa chỉ shipping
            final shippingAddress = {
              "full_name": addressCtrl.selectedAddress!["full_name"],
              "phone": addressCtrl.selectedAddress!["phone"],
              "street": addressCtrl.selectedAddress!["street"],
              "ward": addressCtrl.selectedAddress!["ward"],
              "district": addressCtrl.selectedAddress!["district"],
              "city": addressCtrl.selectedAddress!["city"],
              "country": addressCtrl.selectedAddress!["country"],
            };

            // ==============================
            // CASE 1: COD (direct)
            // ==============================
            if (paymentMethod == "direct") {
              await OrderService.createOrder(
                token: token.toString(),
                paymentMethod: "direct",
                shippingAddress: shippingAddress,
                totalAmount: finalTotal,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
              );
              return;
            }

            // ==============================
            // CASE 2: BANKING (Stripe)
            // ==============================
            if (paymentMethod == "banking") {
              // 1. Tạo PaymentIntent
              final clientSecret = await PaymentService.createPaymentIntent(finalTotal);

              // 2. Mở Stripe Payment Sheet
              final success = await StripeService.pay(clientSecret);

              if (success) {
                // 3. Chỉ tạo order khi thanh toán thành công
                final orderRes = await OrderService.createOrder(
                  token: token.toString(),
                  paymentMethod: "banking",
                  shippingAddress: shippingAddress,
                  totalAmount: finalTotal,
                );
               
                final orderId = orderRes["data"]["order_id"]; // giả sử BE trả về order_id

                // 4. Thêm transaction vào bảng
                await PaymentService.createTransaction(
                  orderId: orderId,
                  provider: "stripe",
                  amount: finalTotal,
                  status: "success",
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Thanh toán thất bại")),
                );
              }
            }
          
          },

          child: Text(
            "Thanh toán \$${finalTotal.toStringAsFixed(2)}",
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


