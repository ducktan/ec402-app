import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:iconsax/iconsax.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.selectedAddress,
    required this.address,
    this.onEdit,
    this.onDelete,
  });

  final bool selectedAddress;
  final Map<String, dynamic> address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dark = THelperFunctions.isDarkMode(context);

    return TRoundedContainer(
      showBorder: true,
      padding: const EdgeInsets.all(TSizes.md),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      backgroundColor: selectedAddress
          ? colorScheme.primaryContainer.withOpacity(0.3)
          : colorScheme.surface,
      borderColor: selectedAddress ? Colors.transparent : theme.dividerColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Biểu tượng tick nếu được chọn
          if (selectedAddress)
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 2),
              child: Icon(Iconsax.tick_circle5, color: colorScheme.primary, size: 20),
            ),

          // ✅ Phần nội dung địa chỉ (chiếm phần lớn không gian)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address['street']}, ${address['ward']}, ${address['district']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: TSizes.sm / 2),
                Text(
                  '${address['city']}, ${address['country']}, ${address['postal_code']}',
                  softWrap: true,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Các nút Edit / Delete (căn phải)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Iconsax.edit_2, size: 18),
                color: colorScheme.primary,
                tooltip: "Edit address",
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Iconsax.trash, size: 18),
                color: Colors.red.shade400,
                tooltip: "Delete address",
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
