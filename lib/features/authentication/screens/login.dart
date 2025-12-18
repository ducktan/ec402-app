import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import SharedPreferences
import 'package:get/get.dart';

// Import các màn hình và service của dự án
import 'signup.dart';
import 'welcome.dart';
import '../../../models/login_model.dart';
import '../../../services/api_service.dart';
import '../../../navigation_menu.dart';
import '../../shop/controllers/home_controller.dart';
import 'package:ec402_app/services/fcm_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool obscurePass = true;
  bool isLoading = false; // ✅ Biến trạng thái loading cho nút bấm

  // Controller
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

            /// --- Email Input
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "E-Mail",
              ),
            ),
            const SizedBox(height: 16),

            /// --- Password Input
            TextFormField(
              controller: passwordController,
              obscureText: obscurePass,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePass ? Icons.visibility_off : Icons.visibility,
                  ),
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
                      onChanged: (v) => setState(() => rememberMe = v ?? false),
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

            /// --- Login Button (Logic chính nằm ở đây)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleLogin, // Disable khi đang load
                child: isLoading 
                  ? const SizedBox(
                      height: 20, width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : const Text("Login"),
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
                      builder: (context) => const SignupScreen(),
                    ),
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

  // --- HÀM XỬ LÝ LOGIN RIÊNG ---
  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true); // Bắt đầu loading
    print(" [Login] Bắt đầu xử lý đăng nhập...");

    try {
      // 1. Gọi API Login
      final res = await ApiService.login(email, password);

      if (res != null) {
        print(" [Login] API Login thành công. Token nhận được.");

        // 2. Lưu Token vào SharedPreferences (QUAN TRỌNG)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', res.token);
        print(" [Login] Đã lưu token vào bộ nhớ máy.");

        // 3. Lấy thông tin User Profile
        // (Bọc try-catch riêng để nếu lỗi lấy profile thì vẫn cho login)
        Map<String, dynamic>? user;
        try {
           user = await ApiService.getUserProfile(res.token);
        } catch (e) {
           print("[Login] Lỗi lấy profile: $e");
        }

        if (user != null) {
          print("👤 [Login] Lấy thông tin user thành công: ${user['name']}");
          
          // Cập nhật Controller GetX
          HomeController.instance.setUser(
            user['name'],
            user['email'],
            user['avatar'],
          );

          // 4. Init FCM (Notification)
          try {
            print("[Login] Đang khởi tạo FCM...");
            await FCMService.initFCM(res.token);
          } catch (e) {
            print("[Login] Lỗi FCM (Bỏ qua): $e");
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Welcome back, ${user['name']}!")),
            );
          }
        } else {
           print("[Login] Không lấy được profile, dùng thông tin mặc định.");
        }

        // 5. CHUYỂN HƯỚNG (Navigation)
        print(" [Login] Chuyển hướng sang NavigationMenu...");
        
        // Sử dụng Get.offAll để xóa màn hình Login khỏi stack (không back lại được)
        Get.offAll(() => const NavigationMenu());
        
      } else {
        // Login thất bại (res == null)
        print(" [Login] API trả về null (Sai tài khoản/mật khẩu)");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed: Invalid email or password")),
          );
        }
      }
    } catch (e) {
      print(" [Login] Lỗi hệ thống: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("System Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false); // Tắt loading dù thành công hay thất bại
      }
    }
  }
}