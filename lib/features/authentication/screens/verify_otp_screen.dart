import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/services/api_service.dart';
import '../../shop/controllers/home_controller.dart';
import '../../../navigation_menu.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone;
  const VerifyOtpScreen({super.key, required this.phone});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 4) {
      Get.snackbar("Lỗi", "Vui lòng nhập mã OTP hợp lệ");
      return;
    }

    setState(() => isLoading = true);
    final result = await ApiService.verifyOTP(widget.phone, otp);
    setState(() => isLoading = false);

    if (result != null) {
      final user = result['user'];

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Welcome ${user['name']}!")),
                      );
        
        Get.offAll(() => const NavigationMenu());
        
        HomeController.instance.setUser(
                        user['name'],
                        user['email'],
                        user['avatar'],
                      );

      
      } else {
        Get.snackbar("Lỗi", "Không lấy được thông tin người dùng");
      }
    } else {
      Get.snackbar("Lỗi", "Xác thực OTP thất bại, vui lòng thử lại!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // === Illustration / Icon ===
              Icon(Icons.verified_user_outlined,
                  size: 90, color: theme.colorScheme.primary),
              const SizedBox(height: 16),

              // === Title & Subtitle ===
              Text(
                'Xác thực mã OTP',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mã xác thực đã được gửi đến số\n${widget.phone}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),

              // === Input field card ===
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: 'Nhập mã OTP',
                        hintText: 'Ví dụ: 123456',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 4,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          isLoading ? 'Đang xác thực...' : 'Xác nhận OTP',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              // === Footer actions ===
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chưa nhận được mã?"),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Get.back(); // quay lại để gửi lại OTP
                          },
                    child: const Text("Gửi lại"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
