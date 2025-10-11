import 'package:ec402_app/features/personalization/screens/profile/profile.dart';
import 'package:ec402_app/features/personalization/screens/settings/settings.dart';
import 'package:ec402_app/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:ec402_app/features/authentication/screens/singup.widgets/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProfileScreen(),
    );
  }
}