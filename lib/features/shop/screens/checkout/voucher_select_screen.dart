import 'package:flutter/material.dart';
import 'package:ec402_app/services/voucher_service.dart';
import 'package:ec402_app/utils/helpers/user_session.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';

class VoucherSelectScreen extends StatefulWidget {
  final double orderTotal;
  final Function(Map<String, dynamic>) onSelected;

  const VoucherSelectScreen({
    super.key,
    required this.orderTotal,
    required this.onSelected,
  });

  @override
  State<VoucherSelectScreen> createState() => _VoucherSelectScreenState();
}

class _VoucherSelectScreenState extends State<VoucherSelectScreen> {
  bool loading = true;
  List vouchers = [];

  @override
  void initState() {
    super.initState();
    loadVouchers();
  }

  loadVouchers() async {
    final token = await UserSession.getToken();

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Bạn chưa đăng nhập")));
      return;
    }

    final data = await VoucherService.fetchVouchers(token);
    setState(() {
      vouchers = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: const Text("Chọn Voucher"), showBackArrow: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, i) {
                final v = vouchers[i];
                return ListTile(
                  title: Text(v["code"]),
                  subtitle: Text(v["description"] ?? ""),
                  trailing: Text("-${v['discount_value']}"),
                  onTap: () async {
                    final token = await UserSession.getToken();
                    final res = await VoucherService.applyVoucher(
                      token: token.toString(),
                      code: v["code"],
                      orderTotal: widget.orderTotal.toDouble(),
                    );

                    final rawData = res["data"];

                    print("==========================");

                    if (res["success"] == true) {
                      final data = Map<String, dynamic>.from(rawData);

                      if (data["discount_amount"] != null) {
                        data["discount_amount"] =
                            (data["discount_amount"] as num).toDouble();
                      }

                      if (data["final_total"] != null) {
                        data["final_total"] = (data["final_total"] as num)
                            .toDouble();
                      }

                      widget.onSelected(data);
                      print('thành công chưa?');
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(res["message"])));
                    }
                  },
                );
              },
            ),
    );
  }
}
