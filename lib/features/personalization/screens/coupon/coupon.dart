import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:ec402_app/features/personalization/screens/coupon/widgets/coupon_card.dart';
import 'package:ec402_app/services/voucher_service.dart';
import 'package:ec402_app/utils/helpers/user_session.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  late Future<List<dynamic>> _vouchersFuture;

  @override
  void initState() {
    super.initState();
    _vouchersFuture = _load();
  }

  Future<List<dynamic>> _load() async {
    final token = await UserSession.getToken();
    return await VoucherService.fetchVouchers(token.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text("Coupons"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: FutureBuilder<List<dynamic>>(
          future: _vouchersFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final vouchers = snapshot.data!;

            if (vouchers.isEmpty) {
              return const Center(child: Text("Không có voucher khả dụng"));
            }

            return ListView.separated(
              itemCount: vouchers.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: TSizes.spaceBtwItems),
              itemBuilder: (_, index) {
                final voucher = vouchers[index];
                return TCouponCard(data: voucher);
              },
            );
          },
        ),
      ),
    );
  }
}
