import 'package:flutter/material.dart';

class TColors {
  TColors._();

  //App basic colors
  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE248);
  static const Color accent = Color(0xFFb0c7ff);

  //Gradient Colors
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xffff9a9e), Color(0xfffad0c4), Color(0xfffad0c4)],
  );

  //Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textWhite = Colors.white;

  //Background Color
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  //Background Container Colors
  static const Color lightContainer = Color(0xfff6f6f6);
  static Color darkContainer = Colors.white.withValues(alpha: 0.1);

  //Button Colors
  static const Color buttonPrimary = Color(0xff4b68ff);
  static const Color buttonSecondary = Color(0xff6c7570);
  static const Color buttonDisabled = Color(0xffc4c4c4);

  //border colors
  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color(0xffe6e6e6);
  static Color get white => Colors.white;
  static Color get darkGrey => const Color(0xFF121212);
  static Color get grey => Colors.grey;
}
