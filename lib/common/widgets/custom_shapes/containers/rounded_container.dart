import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.child,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.backgroundColor = TColors.light,
    this.showBorder = false,
    this.radius = TSizes.cardRadiusLg,
    this.borderColor = TColors.borderPrimary,
  });

  final Widget? child;
  final double? height, width;
  final EdgeInsetsGeometry? padding, margin;
  final Color backgroundColor, borderColor;

  final bool showBorder;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: child,
    );
  }
}
