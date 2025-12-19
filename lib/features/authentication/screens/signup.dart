import 'dart:convert';
import 'package:ec402_app/common/widgets/login_signup/social_buttons.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/common/widgets/login_signup/form_divider.dart';
import 'package:ec402_app/services/api_service.dart';
import 'package:ec402_app/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/helpers/helper_functions.dart';
import '../screens/login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool agreeToTerms = false;

  // Controllers để lấy dữ liệu
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeToTerms) return;

    setState(() => _isLoading = true);

    final signupReq = SignupRequest(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );

    final res = await ApiService.signup(signupReq);

    setState(() => _isLoading = false);

    if (res != null && res.message.contains("success")) {
      // Thành công -> show snackbar + chuyển sang Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful! Please login.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // Lỗi -> show thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res?.message ?? "Signup failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                "Let's create your account",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Full Name
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Iconsax.user),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Enter full name" : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Email
                    TextFormField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: "E-Mail",
                        prefixIcon: Icon(Iconsax.direct),
                      ),
                      validator: (v) =>
                          v == null || !v.contains("@") ? "Enter valid email" : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Phone Number
                    TextFormField(
                      controller: phoneCtrl,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Icon(Iconsax.call),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Iconsax.password_check),
                        suffixIcon: Icon(Iconsax.eye_slash),
                      ),
                      validator: (v) =>
                          v == null || v.length < 6 ? "Min 6 characters" : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Term & Conditions checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: agreeToTerms,
                            onChanged: (value) {
                              setState(() => agreeToTerms = value ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "I agree to ",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: "Privacy Policy ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(
                                        color: dark
                                            ? TColors.white
                                            : TColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                TextSpan(
                                  text: "and ",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: "Terms of Use",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(
                                        color: dark
                                            ? TColors.white
                                            : TColors.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: agreeToTerms && !_isLoading ? _handleSignup : null,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Create Account"),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Divider
              TFormDidiver(dividerText: "Or Sign Up With"),

              const SizedBox(height: TSizes.spaceBtwSections),

              /// Social Buttons
              const TSocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}
