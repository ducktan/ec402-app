import 'package:ec402_app/common/styles/spacing_styles.dart';
import 'package:ec402_app/common/widgets/login_signup/social_buttons.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/common/widgets/login_signup/form_divider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/constants/text_strings.dart';
import '../../../../../../../utils/helpers/helper_functions.dart';
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
 Widget build(BuildContext context){
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///title
              Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Form
              Form(
                child: Column(
                  children: [
                  ///First and Lastname
                  Row(
                    children: [
                      Expanded(child: TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                      ),
                      ),
                      const SizedBox(width: TSizes.spaceBtwInputFields),
                      Expanded(child: TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.lastName, prefixIcon: Icon(Iconsax.user)),
                      ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Username
                  TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.username, prefixIcon: Icon(Iconsax.user_edit)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                  /// Email
                  TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Phone Number
                  TextFormField(
                        expands: false,
                        decoration: InputDecoration(labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Password
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: TTexts.password,
                      prefixIcon: Icon(Iconsax.password_check),
                      suffixIcon: Icon(Iconsax.eye_slash),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Term&Conditions checkbox
                  Row(
                    children: [
                      SizedBox(width: 24, height: 24, child: Checkbox(value: true, onChanged: (value){})),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text.rich(TextSpan(
                        children: [
                          TextSpan(text: '${TTexts.iAgreeTo}', style: Theme.of(context).textTheme.bodySmall),
                          TextSpan(text: '${TTexts.privacyPolicy}', style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: dark ? TColors.white : TColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: dark ? TColors.white : TColors.primary,
                          )),
                          TextSpan(text: '${TTexts.and}', style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(text: TTexts.termsOfUse, style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: dark ? TColors.white : TColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: dark ? TColors.white : TColors.primary,
                          )),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  ///Sign Up Button
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: const Text(TTexts.createAccount)),)
                ],
              ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              ///Didiver
              TFormDidiver(dividerText: TTexts.orSignUpwith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              ///Social Buttons
              const TSocialButton(),
            ],
          ),
        ),
      ),
    );
 }
}

