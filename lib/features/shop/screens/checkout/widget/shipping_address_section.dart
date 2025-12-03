// widgets/checkout/shipping_address_section.dart
import 'package:flutter/material.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle("Shipping Address", context, trailing: "Change"),
        const SizedBox(height: 8),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.location_on_outlined, color: colorScheme.onSurfaceVariant),
          title: Text("Nguyễn Văn A", style: theme.bodyMedium?.copyWith(color: colorScheme.onBackground)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text("0909123456", style: theme.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.home_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text("123 Lê Duẩn, Quận 1, TP.HCM, Việt Nam",
                        style: theme.bodySmall),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Row(
          children: [
            Checkbox(value: true, onChanged: (_) {}, activeColor: colorScheme.primary),
            Expanded(
                child: Text("Billing Address is same as Shipping", style: theme.bodySmall)),
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
