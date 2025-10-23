import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TCircularIcon extends StatelessWidget {
  const TCircularIcon({
    super.key,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.width,
    this.height,
    this.size = TSizes.lg,
    this.onPressed,
  });

  final IconData icon;
  final Color? color, backgroundColor;
  final double? width, height, size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : TColors.white.withOpacity(0.9),
        /*color: backgroundColor != null
            ? backgroundColor! THeplerFunctions.isDarkMode()
                ? TColors.black.withOpacity(0.9)
            : TColors.white.withOpacity(0.9),*/
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: size),
      ),
    );
  }
}
