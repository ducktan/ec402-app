import 'package:ec402_app/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:ec402_app/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:ec402_app/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/products/cart/coupon_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(showBackArrow: true, title: Text('Order Review', style: Theme.of(context).textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // -- Items in Cart
              const TCartItems(showAddRemoveButtons: false),
               SizedBox(height: TSizes.spaceBtwSections),

              // -- Coupon TextField
              TCouponCode(),
               SizedBox(height: TSizes.spaceBtwSections),

              // -- Billing Section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Column(
                  children: [
                    ///billing
                    TBillingPaymentSection(),
                    const SizedBox(height:TSizes.spaceBtwItems),
                    ///divider
                    const Divider(),
                    const SizedBox(height:TSizes.spaceBtwItems),
                    ///payment
                    TBillingPaymentSection(),
                    SizedBox(height: TSizes.spaceBtwItems),
                    ///adress
                    TBillingAddressSection(name: '', phoneNumber: '', address: ''),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => Get.to(() => const CheckoutScreen()),
          child: const Text('Checkout, \$256.0'),
        ),
      ),
    );
  }
}