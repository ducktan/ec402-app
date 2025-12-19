import 'package:flutter/material.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🎉 Animated GIF hoặc ảnh minh họa
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/Order_complete.gif',
                  fit: BoxFit.cover,
                  width: 220,
                  height: 220,
                ),
              ),

              const SizedBox(height: TSizes.spaceBtwItems * 2),

              /// 🏷 Title
              Text(
                'Order Success!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),

              /// 📦 Subtitle
              Text(
                'Your order has been placed successfully.\nWe’ll deliver it soon!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: TColors.textSecondary,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: TSizes.spaceBtwSections * 1.5),

              /// 🔘 Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: TColors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
