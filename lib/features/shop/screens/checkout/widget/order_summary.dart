// widgets/order_summary.dart
import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double taxFee;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.taxFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildRow("Subtotal", subtotal, context),
          _buildRow("Shipping Fee", shippingFee, context),
          _buildRow("Tax Fee", taxFee, context),
          const Divider(),
          _buildRow("Order Total", total, context, bold: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double value, BuildContext context, {bool bold = false}) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              )),
          Text("\$${value.toStringAsFixed(2)}",
              style: theme.bodyMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
