import 'package:ec402_app/features/authentication/screens/signup.dart';
import 'package:ec402_app/features/authentication/screens/login.dart';
import 'package:ec402_app/navigation_menu.dart';
import 'package:ec402_app/features/authentication/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 import GetX
import './features/shop/controllers/home_controller.dart';
import './features/shop/screens/product_detail/product_detail_screen.dart';
import 'package:ec402_app/features/shop/screens/product_review/product_review_screen.dart';


void main() {
  runApp(const MyApp());
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController()); // đăng ký HomeController ở startup
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBindings(),   // 👈 thay MaterialApp bằng GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        primaryColor: Colors.blue.shade800, // màu chính: xanh đậm
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade800, // màu nút, checkbox
          secondary: Colors.blue.shade600,
        ),

        /// TextField style
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade200, // nền xám nhạt
          labelStyle: const TextStyle(color: Colors.black87),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
          ),
        ),

        /// Elevated Button (Login)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),

        /// Outlined Button (Create Account, Google)
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: Colors.blue.shade800),
            foregroundColor: Colors.blue.shade800,
          ),
        ),

        /// Checkbox
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.blue.shade800;
            }
            return Colors.grey;
          }),
        ),
      ),

      home: const NavigationMenu(),
    );
  }
}
