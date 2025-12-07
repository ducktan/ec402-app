// widgets/checkout/shipping_address_section.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/features/personalization/controllers/address_controller.dart';
import '../../../../personalization/screens/address/address.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final AddressController addressCtrl = Get.isRegistered<AddressController>() ? Get.find<AddressController>() : Get.put(AddressController());

    return Obx(() {
      // Loading
      if (addressCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Nếu chưa có địa chỉ nào → yêu cầu chọn
      if (addressCtrl.addresses.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle("Shipping Address", context),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.to(() => const UserAddressScreen()),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_location_alt_outlined,
                        color: colorScheme.primary),
                    const SizedBox(width: 12),
                    Text("Add a shipping address",
                        style: theme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      // Có địa chỉ → lấy địa chỉ được chọn
      final address = addressCtrl.selectedAddress!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle("Shipping Address", context, trailing: "Change", onTapTrailing: () {
            Get.to(() => const UserAddressScreen());
          }),
          const SizedBox(height: 8),

          // Address Info
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.location_on_outlined,
                color: colorScheme.onSurfaceVariant),
            title: Text(
              address['full_name'] ?? "",
              style: theme.bodyMedium?.copyWith(color: colorScheme.onBackground),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(address['phone'] ?? "", style: theme.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.home_outlined,
                        size: 16, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${address['street']}, ${address['ward']}, "
                        "${address['district']}, ${address['city']}, ${address['country']}",
                        style: theme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
                activeColor: colorScheme.primary,
              ),
              Expanded(
                child: Text("Billing Address is same as Shipping",
                    style: theme.bodySmall),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildTitle(String title, BuildContext context,
      {String? trailing, VoidCallback? onTapTrailing}) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground,
          ),
        ),
        if (trailing != null)
          GestureDetector(
            onTap: onTapTrailing,
            child: Text(
              trailing,
              style: theme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
