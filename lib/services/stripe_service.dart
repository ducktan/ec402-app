import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static Future<bool> pay(String clientSecret) async {
    try {
      // 1. Init payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "EC402 Shop",
        ),
      );

      // 2. Present sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      print("Stripe Error: $e");
      return false;
    }
  }
}
