import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:get/get.dart';
import '../../controllers/address_controller.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressCtrl = Get.find<AddressController>();

    // Controllers cho các TextField
    final streetCtrl = TextEditingController();
    final wardCtrl = TextEditingController();
    final districtCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final countryCtrl = TextEditingController();
    final postalCodeCtrl = TextEditingController();

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          child: Column(
            children: [
              // Street
              TextFormField(
                controller: streetCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.building_31),
                  labelText: 'Street',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Ward
              TextFormField(
                controller: wardCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.map_1),
                  labelText: 'Ward',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // District
              TextFormField(
                controller: districtCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.map),
                  labelText: 'District',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // City & Postal Code
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cityCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.home_1),
                        labelText: 'City',
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: postalCodeCtrl,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.code),
                        labelText: 'Postal Code',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Country
              TextFormField(
                controller: countryCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.global),
                  labelText: 'Country',
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.save_2),
                  label: const Text('Save'),
                  onPressed: () async {
                    final newAddress = {
                      "street": streetCtrl.text.trim(),
                      "ward": wardCtrl.text.trim(),
                      "district": districtCtrl.text.trim(),
                      "city": cityCtrl.text.trim(),
                      "country": countryCtrl.text.trim(),
                      "postal_code": postalCodeCtrl.text.trim(),
                    };

                    // Gọi addAddress và kiểm tra kết quả
                    try {
                      await addressCtrl.addAddress(newAddress);

                      // Nếu thành công, hiện snackbar
                      Get.snackbar(
                        "Success",
                        "Address added successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.withOpacity(0.8),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );

                      Get.back(); // quay về list
                    } catch (e) {
                      // Nếu lỗi, hiện snackbar đỏ
                      Get.snackbar(
                        "Error",
                        "Failed to add address. Please try again.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
