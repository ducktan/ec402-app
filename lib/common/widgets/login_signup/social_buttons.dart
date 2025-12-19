import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TSocialButton extends StatelessWidget {
  const TSocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {}, 
            icon: const Icon(
              FontAwesomeIcons.google,
              size: TSizes.iconMd,
              color: Colors.red,
            ),
          ),
        ),

        const SizedBox(width: TSizes.spaceBtwItems),

        // Facebook
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: TColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {}, 
            icon: const Icon(
              FontAwesomeIcons.facebook,
              size: TSizes.iconMd,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
