import 'package:flutter/material.dart';

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
      'brand': 'ZARA',
      'name': 'Blue T-shirt for all ages',
      'price': 35.0,
      'quantity': 1,
      'image': 'assets/images/product1.png',
    },
    {
      'brand': 'Nike',
      'name': 'Nike Track suit red',
      'price': 500.0,
      'quantity': 1,
      'image': 'assets/images/product1.png',
    },
    {
      'brand': 'Nike',
      'name': 'Nike Air Max Red & Black',
      'price': 600.0,
      'quantity': 1,
      'image': 'assets/images/product1.png',
    },
    {
      'brand': 'Apple',
      'name': 'Iphone 14 pro 512gb',
      'price': 1998.0,
      'quantity': 2,
      'image': 'assets/images/product1.png',
    },
  ];

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] as int) + 1;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      final current = cartItems[index]['quantity'] as int;
      cartItems[index]['quantity'] = current > 1 ? current - 1 : 1;
    });
  }

  double get _totalPrice => cartItems.fold<double>(
    0,
    (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int),
  );

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetCacheSize = (56 * devicePixelRatio).round();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼 Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['image']?.toString() ?? 'assets/images/product1.png',
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
                        Row(
                          children: [
                            Text(
                              item['brand']?.toString() ?? '',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 14,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['name'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (item['color'] != null || item['size'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${item['color'] != null ? 'Color ${item['color']}' : ''}'
                              '${item['color'] != null && item['size'] != null ? '   ' : ''}'
                              '${item['size'] != null ? 'Size ${item['size']}' : ''}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),

                        // ➕ Quantity & 💲Price
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onPressed: () => _decrementQuantity(index),
                              visualDensity: VisualDensity.compact,
                            ),
                            Text(
                              '${item['quantity']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 18,
                                color: Colors.blue,
                              ),
                              onPressed: () => _incrementQuantity(index),
                              visualDensity: VisualDensity.compact,
                            ),
                            const Spacer(),
                            Text(
                              '\$${item['price']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
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

      // 🧾 Checkout Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Checkout ${_totalPrice.toStringAsFixed(1)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
