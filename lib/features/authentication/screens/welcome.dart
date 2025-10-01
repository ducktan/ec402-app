import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../utils/constants/sizes.dart';
import 'login.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Logo/Image trên cùng
                Image.asset(
                  "assets/logo/t-store-splash-logo-black.png",
                  height: 250,
                ).animate().fade(duration: 600.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 24),

                /// Title
                Text(
                  "Welcome to T STORE",
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fade(duration: 700.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 8),
                Text(
                  "Shop smart, live better.",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate().fade(duration: 800.ms),

                const SizedBox(height: 32),

                /// Nút Login Email (ăn theo elevatedButtonTheme)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.email),
                    label: const Text("Login with Email & Password"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ).animate().fade(duration: 900.ms).slideX(begin: -0.3, end: 0),

                const SizedBox(height: 16),

                /// Nút Login Phone (ăn theo outlinedButtonTheme)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.phone, color: theme.colorScheme.primary),
                    label: const Text("Login with Phone Number"),
                    onPressed: () {},
                  ),
                ).animate().fade(duration: 1000.ms).slideX(begin: 0.3, end: 0),

                const SizedBox(height: 16),

                /// Nút Google
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    icon: Icon(
                      FontAwesomeIcons.google,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    label: const Text("Sign in with Google"),
                    onPressed: () {},
                  ),
                ).animate().fade(duration: 1100.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                /// Sign Up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ).animate().fade(duration: 1200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
