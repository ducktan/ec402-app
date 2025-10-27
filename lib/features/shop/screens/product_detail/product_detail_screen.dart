import 'package:flutter/material.dart';
import "package:iconsax/iconsax.dart";

import 'package:ec402_app/features/shop/screens/product_detail/widget/product_bottom_bar.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_description.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_image_slider.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_info_section.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_reviews_preview.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_seller_info.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/related_products_section.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.heart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.share),
            onPressed: () {},
          ),
        ],
      ),

      // Nội dung chính
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProductImageSlider(),
            ProductInfoSection(),
            ProductDescription(),
            ProductSellerInfo(sellerName: "Nike Official Store", sellerAvatar: "https://picsum.photos/200",),

            ProductReviewsPreview(),
            RelatedProductsSection(),
          ],
        ),
      ),

      // Thanh hành động dưới cùng
      bottomNavigationBar: const ProductBottomBar(),
    );
  }
}