import 'package:ec402_app/features/authentication/screens/signup.dart';
import 'package:ec402_app/features/authentication/screens/login.dart';
import 'package:ec402_app/features/personalization/screens/profile/profile.dart';
import 'package:ec402_app/features/personalization/screens/settings/settings.dart';
import 'package:ec402_app/features/shop/screens/brand/all_brand.dart';
import 'package:ec402_app/features/shop/screens/home/home.dart';
import 'package:ec402_app/features/shop/screens/store/store.dart';
import 'package:ec402_app/navigation_menu.dart';
import 'package:ec402_app/features/authentication/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 👈 import GetX
import './features/shop/screens/product_detail/product_detail_screen.dart';
import 'package:ec402_app/features/shop/screens/product_review/product_review_screen.dart';
import 'package:ec402_app/features/authentication/screens/welcome.dart';
import 'package:ec402_app/features/personalization/screens/notification/notification.dart';

// Controller
import './features/shop/controllers/home_controller.dart';
import './features/shop/controllers/cart_controller.dart';

// Payment
import 'package:flutter_stripe/flutter_stripe.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart'; // nếu bạn dùng FlutterFire CLI



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}


void main() async {
  Stripe.publishableKey = "pk_test_51Sbhsp3Gd6v4W76iBKFlsl1e6FTUEkpIl4iG8UI7qMGLgbT4HYyChpUF6NGxhFFiddP3ngTFpVLMYT6QQvzq3TdZ00cZWk6h0D";

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController()); // đăng ký HomeController ở startup
    Get.put(CartController()); // đăng ký CartController ở startup
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
  scaffoldBackgroundColor: const Color(0xFFF8F9FA), // nền sáng nhạt
  primaryColor: const Color(0xFFFF6B00),             // cam đậm thương hiệu
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFF6B00),   // nút, checkbox, icon
    secondary: Color(0xFFFF8C1A), // màu nhấn
    surface: Colors.white,
    onPrimary: Colors.white,      // chữ trên nút primary
    onSecondary: Colors.white,    // chữ trên nút secondary
    onSurface: Color(0xFF2B2B2B),// chữ chính trên nền sáng
  ),

  // ===== TextField =====
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    labelStyle: const TextStyle(color: Color(0xFF2B2B2B)),
    hintStyle: TextStyle(color: Colors.grey.shade500),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFFF6B00), width: 2),
    ),
  ),

  // ===== Elevated Button =====
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF6B00),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      elevation: 2,
      shadowColor: const Color(0x33FF6B00),
    ),
  ),

  // ===== Outlined Button =====
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      side: const BorderSide(color: Color(0xFFFF6B00)),
      foregroundColor: const Color(0xFFFF6B00),
    ),
  ),

  // ===== Checkbox =====
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFFFF6B00);
      }
      return Colors.grey;
    }),
  ),

  // ===== AppBar =====
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFF6B00),
    foregroundColor: Color.fromARGB(0, 255, 255, 255),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Colors.white,
    ),
  ),

  // ===== Text theme =====
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: const Color(0xFF2B2B2B)),
    bodySmall: TextStyle(color: const Color(0xFF2B2B2B)),
    labelMedium: TextStyle(color: const Color(0xFF555555)), // text phụ
    headlineSmall: TextStyle(color: const Color(0xFF2B2B2B)), // tiêu đề
  ),
),


      
      home: WelcomeScreen(),
    );
  }
}
