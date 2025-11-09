import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.selectedAddress,
    required this.address, // dữ liệu động
  });

  final bool selectedAddress;
  final Map<String, dynamic> address;

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
      child: Stack(
        children: [
          if (selectedAddress)
            Positioned(
              right: 5,
              top: 0,
              child: Icon(
                Iconsax.tick_circle5,
                color: colorScheme.primary,
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${address['street']}, ${address['ward']}, ${address['district']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: TSizes.sm / 2),
              if (address['phone'] != null)
                Text(
                  '${address['phone']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
        ],
      ),
    );
  }
}
