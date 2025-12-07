// widgets/order_summary.dart
import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double taxFee;
  final double total;

  final double voucherDiscount;   // <--- NEW
  final double finalTotal;        // <--- NEW

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.shippingFee,
    required this.taxFee,
    required this.total,
    required this.voucherDiscount,   // <--- NEW
    required this.finalTotal,        // <--- NEW
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

          // ----- NEW: voucher discount -----
          if (voucherDiscount > 0)
            _buildRow(
              "Voucher Discount",
              -voucherDiscount,
              context,
              bold: true,
              highlight: true,
            ),

          const Divider(),

          _buildRow("Order Total", finalTotal, context, bold: true),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double value,
    BuildContext context, {
    bool bold = false,
    bool highlight = false,
  }) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.bodyMedium?.copyWith(
              color: highlight ? Colors.green : colorScheme.onSurfaceVariant,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "${value < 0 ? '-' : ''}\$${value.abs().toStringAsFixed(2)}",
            style: theme.bodyMedium?.copyWith(
              color: highlight ? Colors.green : colorScheme.onBackground,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
