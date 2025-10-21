import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistItems = [
      {
        'brand': 'Nike',
        'name': 'Green Nike sports shoe',
        'color': 'Green',
        'size': 'EU 34',
        'price': 134.0,
        'image': 'assets/images/product1.png',
      },
      {
        'brand': 'ZARA',
        'name': 'Blue T-shirt for all ages',
        'price': 35.0,
        'size': 'M',
        'image': 'assets/images/product1.png',
      },
      {
        'brand': 'Apple',
        'name': 'Iphone 14 Pro 512gb',
        'price': 1998.0,
        'color': 'Black',
        'image': 'assets/images/product1.png',
      },
    ];

    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetCacheSize = (56 * devicePixelRatio).round();

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist"), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: wishlistItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = wishlistItems[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              isThreeLine: true,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.asset(
                    item['image']?.toString() ?? 'assets/images/product1.png',
                    fit: BoxFit.cover,
                    cacheWidth: targetCacheSize,
                    cacheHeight: targetCacheSize,
                    filterQuality: FilterQuality.low,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/product1.png',
                      fit: BoxFit.cover,
                      cacheWidth: targetCacheSize,
                      cacheHeight: targetCacheSize,
                      filterQuality: FilterQuality.low,
                    ),
                  ),
                ),
              ),
              title: Text(
                item['name'].toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                      const Icon(Icons.verified, size: 14, color: Colors.blue),
                    ],
                  ),
                  if (item['color'] != null || item['size'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${item['color'] != null ? 'Color ${item['color']}' : ''}'
                        '${item['color'] != null && item['size'] != null ? '   ' : ''}'
                        '${item['size'] != null ? 'Size ${item['size']}' : ''}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {},
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (item['price'] != null)
                        Text(
                          "\$${item['price']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              // trailing removed; actions and price are placed in subtitle bottom row
            ),
          );
        },
      ),
    );
  }
}
