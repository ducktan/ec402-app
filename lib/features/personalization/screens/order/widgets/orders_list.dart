import 'package:flutter/material.dart';
import 'package:ec402_app/services/order_api.dart';
import 'package:ec402_app/features/personalization/screens/order/order_detail.dart';

class TOrderListItems extends StatefulWidget {
  const TOrderListItems({Key? key}) : super(key: key);

  @override
  State<TOrderListItems> createState() => _TOrderListItemsState();
}

class _TOrderListItemsState extends State<TOrderListItems> {
  late Future<List<dynamic>> _orders;

  @override
  void initState() {
    super.initState();
    _orders = OrderService.getMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Failed: ${snapshot.error}"));
        }

        final orders = snapshot.data as List;

        return ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final order = orders[index];

            return ListTile(
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text("Order #${order["id"]}"),
              subtitle: Text("Total: \$${order["total_amount"]}"),
              trailing: Text(order["order_status"]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(orderId: order['id']),
                  ),
                ).then((result) {
                  if (result == true) {
                    setState(() {
                      _orders = OrderService.getMyOrders(); // Reload list
                    });
                  }
                });
              },
            );
          },
        );
      },
    );
  }
}
