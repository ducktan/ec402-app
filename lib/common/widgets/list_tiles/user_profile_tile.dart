import 'package:ec402_app/common/widgets/images/t_circular_image.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../features/shop/controllers/home_controller.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final homeCtrl = HomeController.instance;

    return Obx(() => ListTile(
          onTap: onPressed,

          // 🟢 Avatar động
          leading: TCircularImage(
            image: homeCtrl.avatarUrl.value.isNotEmpty
                ? homeCtrl.avatarUrl.value
                : TImages.user, // fallback ảnh mặc định
            isNetworkImage: homeCtrl.avatarUrl.value.isNotEmpty,
            width: 50,
            height: 50,
            padding: 0,
          ),

          // 🟢 Username
          title: Text(
            homeCtrl.username.value.isNotEmpty
                ? homeCtrl.username.value
                : "Guest",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: TColors.white),
          ),

          // 🟢 Email
          subtitle: Text(
            homeCtrl.email.value.isNotEmpty
                ? homeCtrl.email.value
                : "example@email.com",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: TColors.white),
          ),

          trailing: IconButton(
            onPressed: onPressed,
            icon: const Icon(Iconsax.edit, color: TColors.white),
          ),
        ));
  }
}
