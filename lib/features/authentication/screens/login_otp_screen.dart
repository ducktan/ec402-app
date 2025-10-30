import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'verify_otp_screen.dart';
import 'package:ec402_app/services/api_service.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại hợp lệ')),
      );
      return;
    }

    setState(() => isLoading = true);
    final success = await ApiService.loginOTP(phone);
    setState(() => isLoading = false);

    if (success && context.mounted) {
      Get.to(() => VerifyOtpScreen(phone: phone));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Không thể gửi OTP, vui lòng thử lại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập bằng OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.phone_android, size: 100, color: theme.primaryColor),
            const SizedBox(height: 32),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isLoading ? 'Đang gửi OTP...' : 'Gửi OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
