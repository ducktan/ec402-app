import 'package:flutter/material.dart';
import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:ec402_app/utils/constants/text_strings.dart';
import 'package:ec402_app/utils/constants/image_strings.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Column(
                children: [
                  Image(
                    width: THelperFunctions.screenWidth() * 0.8,
                    height: THelperFunctions.screenWidth()*0.6,
                    image: const AssetImage(TImages.tOnBoardingImage1),
                    ),
                  Text(TTexts.tOnBoardingTitle1,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: TSizes.spaceBtwItems ),
                  Text(TTexts.tOnBoardingSubTitle1,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

