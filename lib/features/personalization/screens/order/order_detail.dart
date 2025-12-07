import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/common/widgets/images/t_circular_image.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:ec402_app/services/order_api.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? order; // Data
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrderDetail();
  }

  Future<void> fetchOrderDetail() async {
    try {
      final data = await OrderService.getDetailOrder(widget.orderId);
      setState(() {
        order = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        loading = false;
      });
    }
  }

  Future<void> cancelOrder() async {
    try {
      final success = await OrderService.cancelOrder(widget.orderId);
      if (success) {
        setState(() {
          order!["order_status"] = "cancelled";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order cancelled successfully")),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to cancel order: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!, style: theme.textTheme.bodyLarge)),
      );
    }

    final shipping = order!["shipping_address"];
    final items = order!["items"] as List<dynamic>;
    final paymentMethod = order!["payment_method"] == "direct"
    ? "Cash on Delivery (COD)"
    : "Bank Transfer";

    return Scaffold(
      appBar: TAppBar(
        title: Text("Order #${order!["id"]}"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- ORDER SUMMARY ----------------
            _SectionHeader(icon: Iconsax.bag_2, title: "Order Summary"),
            const SizedBox(height: 12),
            TRoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(TSizes.md),
              borderColor: colorScheme.outlineVariant,
              child: Column(
                children: [
                  _row("Order ID:", "#${order!["id"]}", context),
                  _row("Placed on:", order!["created_at"], context),
                  _row("Total Amount:", "\$${order!["total_amount"]}", context),
                  _row("Status:", order!["order_status"], context),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ---------------- ITEMS ----------------
            _SectionHeader(icon: Iconsax.shopping_cart, title: "Items"),
            const SizedBox(height: 12),

            ...items.map((item) {
            
              return TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                borderColor: colorScheme.outlineVariant,
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TCircularImage(
                      image: item['image_url'] ?? TImages.noImage,
                      width: 80,
                      height: 80,
                      isNetworkImage: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item["name"],
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text("Unit Price: \$${item["price"]}",
                              style: theme.textTheme.labelMedium),
                          Text("Quantity: ${item["quantity"]}",
                              style: theme.textTheme.labelMedium),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ---------------- SHIPPING ADDRESS ----------------
            _SectionHeader(icon: Iconsax.location, title: "Shipping Address"),
            const SizedBox(height: 12),
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              borderColor: colorScheme.outlineVariant,
              showBorder: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _address("Name", shipping["full_name"]),
                  _address("Phone", shipping["phone"]),
                  _address("Country", shipping["country"]),
                  _address("City", shipping["city"]),
                  _address("District", shipping["district"]),
                  _address("Ward", shipping["ward"]),
                  _address("Street", shipping["street"]),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ---------------- PAYMENT ----------------
            _SectionHeader(icon: Iconsax.wallet_2, title: "Payment Details"),
            const SizedBox(height: 12),
            TRoundedContainer(
              padding: const EdgeInsets.all(TSizes.md),
              borderColor: colorScheme.outlineVariant,
              showBorder: true,
              child: Column(
                children: [
                  _row("Payment Method:", paymentMethod, context),
                  // _row("Subtotal:", "\$${order!["subtotal"]}", context),
                  // _row("Delivery Fee:", "\$${order!["shipping_fee"]}", context),
                  const Divider(),
                  _row("Total:", "\$${order!["total_amount"]}", context, bold: true),
                ],
              ),
            ),
            // ------- CANCEL ORDER BUTTON -------
            if (order!["order_status"] == "pending") ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Confirm cancellation"),
                        content: const Text("Are you sure you want to cancel this order?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              cancelOrder();
                            },
                            child: const Text("Yes, Cancel"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Cancel Order"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, BuildContext context, {bool bold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: bold
                ? theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _address(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 10),
        Text(title, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
