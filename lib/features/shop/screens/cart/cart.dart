import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/shop/screens/checkout/checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> cartItems = [
    {
      'brand': 'Nike',
      'name': 'Green Nike sports shoe',
      'color': 'Green',
      'size': 'EU 34',
      'price': 134.0,
      'quantity': 1,
      'image': 'assets/images/product1.png',
    },
    {
      'brand': 'Apple',
      'name': 'iPhone 14 Pro 512GB',
      'price': 1998.0,
      'quantity': 1,
      'image': 'assets/images/product1.png',
    },
  ];

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final current = cartItems[index]['quantity'] as int;
      if (current > 1) cartItems[index]['quantity'] = current - 1;
    });
  }

  double get _totalPrice => cartItems.fold<double>(
        0,
        (sum, item) =>
            sum + (item['price'] as double) * (item['quantity'] as int),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetCacheSize = (56 * devicePixelRatio).round();

    return Scaffold(
      backgroundColor: colorScheme.background,

      // ===== AppBar =====
      appBar: const TAppBar(
        title: Text("Cart"),
        showBackArrow: true,
      ),

      // ===== Body =====
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼 Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['image'] ?? 'assets/images/product1.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      cacheWidth: targetCacheSize,
                      cacheHeight: targetCacheSize,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 📝 Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['brand'] ?? '',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: colorScheme.onBackground)),
                        const SizedBox(height: 2),
                        Text(
                          item['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onBackground),
                        ),
                        if (item['color'] != null || item['size'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${item['color'] != null ? 'Color ${item['color']}' : ''}'
                              '${item['color'] != null && item['size'] != null ? '   ' : ''}'
                              '${item['size'] != null ? 'Size ${item['size']}' : ''}',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: colorScheme.onBackground),
                            ),
                          ),
                        const SizedBox(height: 10),

                        // ➕ Quantity & 💲Price
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove,
                                  size: 18, color: colorScheme.onBackground),
                              onPressed: () => _decrementQuantity(index),
                              visualDensity: VisualDensity.compact,
                            ),
                            Text('${item['quantity']}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onBackground)),
                            IconButton(
                              icon: Icon(Icons.add,
                                  size: 18, color: colorScheme.primary),
                              onPressed: () => _incrementQuantity(index),
                              visualDensity: VisualDensity.compact,
                            ),
                            const Spacer(),
                            Text('\$${item['price']}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onBackground,
                                    fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // ===== Checkout Button =====
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(
                    cartItem: {
                      'title': cartItems.first['name'],
                      'price': _totalPrice,
                      'image': cartItems.first['image'],
                      'variant':
                          cartItems.first['color'] ?? cartItems.first['size'] ?? '',
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Checkout \$${_totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
