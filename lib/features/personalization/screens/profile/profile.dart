import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/images/t_circular_image.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user;
        if (user.isEmpty) {
          return const Center(child: Text("No user data found"));
        }

        // --- Controllers cho các TextField ---
        final nameCtrl = TextEditingController(text: user['name'] ?? '');
        final phoneCtrl = TextEditingController(text: user['phone'] ?? '');
        final dobCtrl = TextEditingController(text: user['dob'] ?? '');
        String selectedGender = user['gender'] ?? 'other';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // --- Avatar ---
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    TCircularImage(
                      image: user['avatar'] ?? TImages.user,
                      width: 100,
                      height: 100,
                      isNetworkImage: user['avatar'] != null,
                    ),
                    TextButton(
                      onPressed: controller.pickAvatar,
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              // --- Name ---
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
              const SizedBox(height: 16),

              // --- Phone ---
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Iconsax.call),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // --- Gender Dropdown ---
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Iconsax.user_tag),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (val) {
                  selectedGender = val!;
                },
              ),
              const SizedBox(height: 16),

              // --- Date of Birth ---
              TextField(
                controller: dobCtrl,
                decoration: InputDecoration(
                  labelText: 'Date of Birth (YYYY-MM-DD)',
                  prefixIcon: const Icon(Iconsax.calendar_1),
                  suffixIcon: IconButton(
                    icon: const Icon(Iconsax.calendar),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse(user['dob'] ?? '') ?? DateTime(2000),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dobCtrl.text = picked.toIso8601String().split('T')[0];
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- Save Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Iconsax.save_2),
                  label: const Text('Save Changes'),
                  onPressed: () async {
                    await controller.updateProfile({
                      'name': nameCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                      'gender': selectedGender,
                      'dob': dobCtrl.text.trim(),
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: controller.closeAccount,
                child: const Text(
                  'Close Account',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
