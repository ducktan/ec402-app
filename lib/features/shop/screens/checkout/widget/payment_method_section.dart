import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selected;
  final Function(String method) onSelect;

  const PaymentMethodSection({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle("Payment Method", context, trailing: "Change"),
        const SizedBox(height: 12),

        _buildPaymentItem(
          icon: Iconsax.money,
          label: "Thanh toán khi nhận (COD)",
          value: "direct",
          isSelected: selected == "direct",
          context: context,
          onSelect: onSelect,
        ),
        const SizedBox(height: 12),

        _buildPaymentItem(
          icon: Iconsax.scan_barcode,
          label: "Thanh toán VietQR",
          value: "banking",
          isSelected: selected == "banking",
          context: context,
          onSelect: onSelect,
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
              fontWeight: FontWeight.bold,
            )),
        if (trailing != null)
          Text(trailing,
              style: theme.bodySmall
                  ?.copyWith(color: colorScheme.primary)),
      ],
    );
  }

  /// Payment Item
  Widget _buildPaymentItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isSelected,
    required BuildContext context,
    required Function(String method) onSelect,
  }) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onSelect(value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle,
                  color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
