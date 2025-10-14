import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'signup.dart';
import 'welcome.dart';
import '../../../models/login_model.dart';
import '../../../services/api_service.dart'; // ✅ import ApiService
import '../../../navigation_menu.dart'; // ✅ import NavigationScreen
import 'package:get/get.dart';
import '../../shop/controllers/home_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool obscurePass = true;

  // --- TextEditingController cho email & password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: dark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// --- Logo
            Image.asset(
              dark
                  ? "assets/logo/t-store-splash-logo-white.png"
                  : "assets/logo/t-store-splash-logo-black.png",
              height: 120,
            ),
            const SizedBox(height: 20),

            /// --- Title
            Text(
              "Welcome back",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Discover limitless choices and unmatched convenience",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            /// --- Email
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "E-Mail",
              ),
            ),
            const SizedBox(height: 16),

            /// --- Password
            TextFormField(
              controller: passwordController,
              obscureText: obscurePass,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                      obscurePass ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() => obscurePass = !obscurePass);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// --- Remember me + Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (v) =>
                          setState(() => rememberMe = v ?? false),
                    ),
                    const Text("Remember Me"),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// --- Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  final res = await ApiService.login(email, password); // ✅ gọi ApiService

                  if (res != null) {
                    print("Token: ${res.token}");
                    print("User: ${res.user.name} - ${res.user.email}");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Welcome ${res.user.name}!"),
                      ),
                    );

                    // 👉 Điều hướng sang màn hình Navigation
                    Get.offAll(() => const NavigationMenu());
                    HomeController.instance.setUser(res.user.name);


                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Login failed"),
                      ),
                    );
                  }
                },
                child: const Text("Login"),
              ),
            ),
            const SizedBox(height: 12),

            /// --- Signup Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text("Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
