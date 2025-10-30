import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/services/api_service.dart';
import '../../shop/screens/home/home.dart';
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
    setState(() => isLoading = true);

    final result = await ApiService.verifyOTP(widget.phone, otpController.text);

    if (result != null) {
      final token = result['token'];

      // Gọi API lấy thông tin user
      print(token);
      final user = await ApiService.getUserProfile(token);

      if (user != null) {
        final homeCtrl = Get.put(HomeController());
        homeCtrl.setUser(user['name'], user['email'], user['avatar']); // 👈 thêm email

        // Có thể lưu token vào GetStorage / SharedPrefs
        // await LocalStorage.saveToken(token);

        Get.offAll(() => const NavigationMenu());
      } else {
        Get.snackbar("Lỗi", "Không lấy được thông tin người dùng");
      }
    } else {
      Get.snackbar("Lỗi", "Xác thực OTP thất bại, vui lòng thử lại!");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác thực OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: "Nhập OTP"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : verifyOtp,
              child: Text(isLoading ? 'Đang xác thực...' : 'Xác nhận OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
