import 'package:flutter/material.dart';

class TCouponCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TCouponCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final code = data["code"] ?? "";
    final desc = data["description"] ?? "";
    final discountType = data["discount_type"];
    final discountValue = data["discount_value"];
    final expires = data["expires_at"];

    // Màu sắc từ theme
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface, // nền trắng từ theme
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.4)), // đường viền cam nhẹ
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CODE
          Text(
            code,
            style: theme.textTheme.headlineSmall!.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          /// DESCRIPTION
          Text(
            desc,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: textColor.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 8),

          /// DISCOUNT DISPLAY
          Text(
            discountType == "percent"
                ? "Giảm $discountValue%"
                : "Giảm $discountValueđ",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          /// EXPIRY
          if (expires != null)
            Text(
              "Hạn dùng: ${expires.toString().substring(0, 10)}",
              style: theme.textTheme.bodySmall!.copyWith(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
