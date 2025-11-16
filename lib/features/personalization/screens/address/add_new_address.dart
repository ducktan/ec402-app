import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import '../../controllers/address_controller.dart';
import './address.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final addressCtrl = Get.find<AddressController>();

  final streetCtrl = TextEditingController();
  final postalCodeCtrl = TextEditingController();

  List provinces = [];
  List districts = [];
  List wards = [];

  String? selectedProvinceCode;
  String? selectedDistrictCode;
  String? selectedWardCode;

  Map<String, dynamic>? editingAddress; // ✅ Dữ liệu edit (nếu có)

  @override
  void initState() {
    super.initState();
    loadProvinceData();
  }

  /// ✅ Load dữ liệu tỉnh/thành từ file JSON
  Future<void> loadProvinceData() async {
    final jsonString = await rootBundle.loadString('assets/data/vn_provinces.json');
    final data = json.decode(jsonString) as List;
    provinces = data;

    // Nếu có địa chỉ cần chỉnh sửa, fill vào
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      editingAddress = args;
      fillFormWithData();
    }
    setState(() {});
  }

  /// ✅ Điền dữ liệu cũ vào form khi edit
  void fillFormWithData() {
    if (editingAddress == null) return;

    streetCtrl.text = editingAddress!['street'] ?? '';
    postalCodeCtrl.text = editingAddress!['postal_code'] ?? '';

    final cityName = editingAddress!['city'];
    final districtName = editingAddress!['district'];
    final wardName = editingAddress!['ward'];

    // Tìm code của city, district, ward tương ứng theo name
    final city = provinces.firstWhereOrNull((p) => p['name'] == cityName);
    if (city != null) {
      selectedProvinceCode = city['code'].toString();
      districts = city['districts'] ?? [];

      final district = districts.firstWhereOrNull((d) => d['name'] == districtName);
      if (district != null) {
        selectedDistrictCode = district['code'].toString();
        wards = district['wards'] ?? [];

        final ward = wards.firstWhereOrNull((w) => w['name'] == wardName);
        if (ward != null) selectedWardCode = ward['code'].toString();
      }
    }
  }

  void selectProvince(String code) {
    final selected = provinces.firstWhere((p) => p['code'].toString() == code);
    setState(() {
      selectedProvinceCode = code;
      districts = selected['districts'] ?? [];
      selectedDistrictCode = null;
      wards = [];
      selectedWardCode = null;
    });
  }

  void selectDistrict(String code) {
    final selected = districts.firstWhere((d) => d['code'].toString() == code);
    setState(() {
      selectedDistrictCode = code;
      wards = selected['wards'] ?? [];
      selectedWardCode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = editingAddress != null;

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(isEditing ? 'Edit Address' : 'Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
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

            // Province
            DropdownButtonFormField<String>(
              value: selectedProvinceCode,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.home_1),
                labelText: 'City / Province',
              ),
              items: provinces
                  .map((p) => DropdownMenuItem(
                        value: p['code'].toString(),
                        child: Text(p['name']),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectProvince(val);
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // District
            DropdownButtonFormField<String>(
              value: selectedDistrictCode,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.map),
                labelText: 'District / Huyện',
              ),
              items: districts
                  .map((d) => DropdownMenuItem(
                        value: d['code'].toString(),
                        child: Text(d['name']),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) selectDistrict(val);
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Ward
            DropdownButtonFormField<String>(
              value: selectedWardCode,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.map_1),
                labelText: 'Ward / Xã',
              ),
              items: wards
                  .map((w) => DropdownMenuItem(
                        value: w['code'].toString(),
                        child: Text(w['name']),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedWardCode = val;
                });
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Postal Code
            TextFormField(
              controller: postalCodeCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.code),
                labelText: 'Postal Code',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Country
            TextFormField(
              initialValue: "Việt Nam",
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.global),
                labelText: 'Country',
              ),
              enabled: false,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Iconsax.save_2),
                label: Text(isEditing ? 'Update' : 'Save'),
                onPressed: () async {
                  if (selectedProvinceCode == null ||
                      selectedDistrictCode == null ||
                      selectedWardCode == null) {
                    Get.snackbar("Error", "Please select Province, District and Ward",
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  final selectedProvinceName = provinces.firstWhere(
                    (e) => e['code'].toString() == selectedProvinceCode,
                  )['name'];
                  final selectedDistrictName = districts.firstWhere(
                    (e) => e['code'].toString() == selectedDistrictCode,
                  )['name'];
                  final selectedWardName = wards.firstWhere(
                    (e) => e['code'].toString() == selectedWardCode,
                  )['name'];

                  final data = {
                    "street": streetCtrl.text.trim(),
                    "ward": selectedWardName,
                    "district": selectedDistrictName,
                    "city": selectedProvinceName,
                    "postal_code": postalCodeCtrl.text.trim(),
                    "country": "Việt Nam",
                  };

                  try {
                    bool success;
                    if (isEditing) {
                      // ✅ Cập nhật địa chỉ
                      success = await addressCtrl.updateAddress(editingAddress!['id'], data);
                    } else {
                      // ✅ Thêm mới địa chỉ
                      success = await addressCtrl.addAddress(data);
                    }

                    if (success) {
                      Get.back();
                      Get.snackbar(
                        "Success",
                        isEditing ? "Address updated successfully!" : "Address added successfully!",
                        backgroundColor: Colors.green.withOpacity(0.8),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } catch (e) {
                    Get.snackbar("Error", "Failed to save address. Please try again.",
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
