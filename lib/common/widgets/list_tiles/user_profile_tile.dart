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

    return Obx(() {
      final avatar = homeCtrl.avatarUrl.value;
      final name = homeCtrl.username.value.isNotEmpty
          ? homeCtrl.username.value
          : "Guest";
      final email = homeCtrl.email.value.isNotEmpty
          ? homeCtrl.email.value
          : "example@email.com";

      return ListTile(
        onTap: onPressed,

        // 🟢 Avatar hình tròn động (reactive)
        leading: TCircularImage(
          image: avatar.isNotEmpty ? avatar : TImages.user,
          isNetworkImage: avatar.isNotEmpty,
          width: 55,
          height: 55,
          padding: 0,
        ),

        // 🟢 Tên người dùng
        title: Text(
          name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: TColors.white),
          overflow: TextOverflow.ellipsis,
        ),

        // 🟢 Email
        subtitle: Text(
          email,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .apply(color: TColors.white.withOpacity(0.8)),
          overflow: TextOverflow.ellipsis,
        ),

        trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(Iconsax.edit, color: TColors.white),
        ),
      );
    });
  }
}
