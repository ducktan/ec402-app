import 'package:flutter/material.dart';
import "package:iconsax/iconsax.dart";

import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_bottom_bar.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_description.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_image_slider.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_info_section.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_reviews_preview.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_seller_info.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/related_products_section.dart';
import 'package:get/get.dart';
import '../../controllers/brand_controller.dart';


class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final BrandController brandController = Get.put(BrandController());

  @override
  void initState() {
    super.initState();
    _loadBrand();
  }

  Future<void> _loadBrand() async {
    final brandId = widget.product['brand_id'];
    if (brandId != null) {
      await brandController.fetchBrandById(brandId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.product;
    final productId = data['id'] ?? 0;
    final productName = data['name'] ?? "Unknown Product";
    final productPrice = data['price'] ?? "0";
    final productImage = data['image_url'] ?? "https://via.placeholder.com/150";
    final productStock = data['stock'] ?? 0;

    return Scaffold(
      appBar: TAppBar(title: Text(productName), showBackArrow: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSlider(images: [productImage]),
            ProductInfoSection(
              name: productName,
              price: productPrice,
              rating: double.tryParse(data['rating_avg'] ?? "0") ?? 0.0,
              stock: productStock,
            ),
            ProductDescription(description: data['description'] ?? ""),
            Obx(() {
              final sellerName =
                  brandController.brand['name'] ?? "Loading...";
              final sellerAvatar =
                  brandController.brand['logo_url'] ?? "https://picsum.photos/200";

              return ProductSellerInfo(
                sellerName: sellerName,
                sellerAvatar: sellerAvatar,
              );
            }),
            ProductReviewsPreview(productId: productId),
            const RelatedProductsSection(),
          ],
        ),
      ),
      bottomNavigationBar: const ProductBottomBar(),
    );
  }
}
