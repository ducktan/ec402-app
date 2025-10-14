import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: TColors.darkerGrey,
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadow = BoxShadow(
    color: TColors.darkerGrey,
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(2, 0),
  );
}
