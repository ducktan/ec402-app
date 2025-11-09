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

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,

      // ===== AppBar =====
      appBar: TAppBar(
        showBackArrow: true,
        title: const Text("Product Detail"),
        actions: [
          IconButton(
            icon: Icon(Iconsax.heart, color: colorScheme.onBackground),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Iconsax.share, color: colorScheme.onBackground),
            onPressed: () {},
          ),
        ],
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProductImageSlider(),
            ProductInfoSection(),
            ProductDescription(),
            ProductSellerInfo(
              sellerName: "Nike Official Store",
              sellerAvatar: "https://picsum.photos/200",
            ),
            ProductReviewsPreview(),
            RelatedProductsSection(),
          ],
        ),
      ),

      // ===== Bottom Bar =====
      bottomNavigationBar: const ProductBottomBar(),
    );
  }
}
