import 'package:ec402_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class TCircularImage extends StatelessWidget{
  const TCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.isNetworkImage = false,

  });
  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;


  @override
  Widget build(BuildContext context) {
    final imageWidget = isNetworkImage
        ? Image.network(image, fit: BoxFit.cover)
        : Image.asset(image, fit: BoxFit.cover);

    return ClipOval(
      child: Container(
        width: width,
        height: height,
        color: backgroundColor ?? Colors.grey.shade200,
        child: imageWidget,
      ),
    );
  }

  
}