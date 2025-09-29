import 'package:ec402_app/common/styles/spacing_styles.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage(dark ? TImages.lightAppLogo: TImages.darkAppLogo),
                  ),
                  Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: TSizes.sm,),
                  Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium,)
                ],
              ),
              Form(child: Padding(
                padding: const EdgeInsets.symmetric(vertical:TSizes.spaceBtwSections),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: TTexts.email,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields,),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check),
                        labelText: TTexts.password,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields / 2),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (value){}),
                            const Text(TTexts.rememberMe)
                          ],
                        ),
                        TextButton(onPressed: (){}, child: const Text(TTexts.forgetPassword),)
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text(TTexts.signupTitle))),
                    SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () {}, child: const Text(TTexts.yourAccountCreatedTitle))),
                    const SizedBox(height: TSizes.spaceBtwSections),

                  ],

                ),
              ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Divider(color: dark ? TColors.darkerGrey : TColors.grey,thickness: 0.5, indent: 60,endIndent: 5)),
                  Flexible(child: Divider(color: dark ? TColors.darkerGrey : TColors.grey,thickness: 0.5, indent: 5,endIndent: 60)),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
                    child: IconButton(onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.google, size: TSizes.iconMd, color: Colors.red,)),
                  )
                ],
              )
            ],
          )
        ),
      )
    );
  }
}
