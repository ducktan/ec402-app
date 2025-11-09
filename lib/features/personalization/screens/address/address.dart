import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/personalization/screens/address/add_new_address.dart';
import 'package:ec402_app/features/personalization/screens/address/widgets/single_address.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/address_controller.dart';
import 'package:iconsax/iconsax.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressCtrl = Get.put(AddressController());
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Addresses',
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (addressCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final addresses = addressCtrl.addresses;

        if (addresses.isEmpty) {
          return Center(
            child: Text(
              "No addresses found",
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: List.generate(
              addresses.length,
              (index) => TSingleAddress(
                selectedAddress: index == 0, // highlight địa chỉ đầu tiên
                address: addresses[index],
              ),
            ),
          ),
        );
      }),
    );
  }
}
