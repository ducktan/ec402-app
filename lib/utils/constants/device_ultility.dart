import 'package:flutter/material.dart';

class TDeviceUtils {
  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
