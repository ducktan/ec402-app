// widgets/checkout/payment_method_section.dart
import 'package:flutter/material.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle("Payment Method", context, trailing: "Change"),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.payments_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text("Cash On Delivery",
                style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: colorScheme.onBackground)),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(String title, BuildContext context, {String? trailing}) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: theme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: colorScheme.onBackground)),
        if (trailing != null)
          Text(trailing, style: theme.bodySmall?.copyWith(color: colorScheme.primary)),
      ],
    );
  }
}
