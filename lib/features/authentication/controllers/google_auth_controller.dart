import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../services/api_service.dart';
import '../../../utils/helpers/user_session.dart';

class GoogleAuthController extends GetxController {
  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  var isLoading = false.obs;

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.snackbar("Cancelled", "Google login cancelled");
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      // 🔥 Gửi ID Token đến backend để xác thực và lấy JWT app
      final result = await ApiService.loginWithGoogle(idToken!);
      if (result != null && result['token'] != null) {
        await UserSession.saveUserSession(
          token: result['token'],
          userId: result['user']['id'],
          name: result['user']['name'],
          email: result['user']['email'],
          role: result['user']['role'] ?? 'user',
        );
        Get.offAllNamed('/home');
        Get.snackbar("Success", "Welcome ${result['user']['name']}");
      } else {
        Get.snackbar("Error", "Failed to sign in with Google");
      }
    } catch (e) {
      Get.snackbar("Error", "Google sign-in failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
