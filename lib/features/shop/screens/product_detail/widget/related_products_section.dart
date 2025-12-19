import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ec402_app/features/shop/screens/product_detail/product_detail_screen.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<Map<String, dynamic>> relatedProducts;

  const RelatedProductsSection({super.key, required this.relatedProducts});

  @override
  Widget build(BuildContext context) {
    if (relatedProducts.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Sản phẩm liên quan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          // ListView horizontal
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: relatedProducts.length,
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                final imageUrl =
                    product['image_url'] ?? "https://via.placeholder.com/150";
                final name = product['name'] ?? "Unknown";
                final price = product['price'] != null
                    ? "${product['price']} VNĐ"
                    : "";

                return GestureDetector(
                  onTap: () {
                    print("→ Tap related: ${product['name']}");
                    Get.to(() => ProductDetailScreen(product: product));
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ảnh sản phẩm
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // Tên + giá
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                              if (price.isNotEmpty)
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
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
          ),
        ],
      ),
    );
  }
}
