import 'package:flutter/material.dart';
import '../voucher_select_screen.dart';

class CouponSection extends StatelessWidget {
  final double orderTotal;
  final Map<String, dynamic>? selectedVoucher;
  final Function(Map<String, dynamic>) onVoucherApplied;

  const CouponSection({
    super.key,
    required this.orderTotal,
    required this.selectedVoucher,
    required this.onVoucherApplied,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
            title: Text(
              'Apply Coupon/Vouchers',
              style: theme.bodyMedium,
            ),

            // ---- FIXED SUBTITLE ----
            subtitle: selectedVoucher != null
                ? Text(
                    "Đã áp dụng: ${selectedVoucher!['code']} "
                    "(-\$${selectedVoucher!['discount_amount'].toStringAsFixed(2)})",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,

            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoucherSelectScreen(
                    orderTotal: orderTotal,
                    onSelected: (voucher) {
                      onVoucherApplied(voucher);
                    },
                  ),
                ),
              );
            },
          ),

          const Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Points: 0', style: theme.bodySmall),
              Switch(value: false, onChanged: (val) {}),
            ],
          ),
        ],
      ),
    );
  }
}
