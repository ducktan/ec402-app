import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/images/t_circular_image.dart';
import 'package:ec402_app/common/widgets/texts/section_heading.dart';
import 'package:ec402_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      /// -- Body
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            /// profile Picture
            SizedBox(
              width: double.infinity,
            child: Column(
              children: [
                const TCircularImage(image: TImages.user, width: 80, height: 80),
                TextButton(onPressed: (){}, child: const Text('Change Profile Picture')),
              ],
            ),
            ),
            /// Details
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            const TSectionHeading(title: 'Profile Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(title: 'Name', value: 'nhom mobile', onPressed: (){}),
            TProfileMenu(title: 'Username', value: 'nhom mobile', onPressed: (){}),
            const SizedBox(height: TSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Heading Personal Info
            const TSectionHeading(title: 'Personal Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(title: 'User ID', value: '45678', icon: Iconsax.copy, onPressed: (){}),
            TProfileMenu(title: 'E-mail', value: 'nhom mobile', onPressed: (){}),
            TProfileMenu(title: 'Phone Number', value: '+848488789', onPressed: (){}),
            TProfileMenu(title: 'Gender', value: 'Male', onPressed: (){}),
            TProfileMenu(title: 'Date Of Birth', value: '22 Aug 2020', onPressed: (){}),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            Center(
              child: TextButton(onPressed: () {}, 
              child: const Text('Close Account', style: TextStyle(color: Colors.red)),
            ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}