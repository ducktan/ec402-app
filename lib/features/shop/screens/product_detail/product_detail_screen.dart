import 'package:flutter/material.dart';
import 'package:get/get.dart';
// utils
import 'package:ec402_app/utils/constants/image_strings.dart';

import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_bottom_bar.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_description.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_image_slider.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_info_section.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_reviews_preview.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/product_seller_info.dart';
import 'package:ec402_app/features/shop/screens/product_detail/widget/related_products_section.dart';

import '../../controllers/brand_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/wishlist_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final BrandController brandController;
  late final ProductController productController;
  late final WishlistController wishlistController;

  @override
  void initState() {
    super.initState();

    // Put controllers (tồn tại hoặc tạo mới)
    brandController = Get.put(BrandController());
    productController = Get.put(ProductController());
    wishlistController = Get.put(WishlistController());

    _loadData();
  }

  Future<void> _loadData() async {
    final productId = widget.product['id'];
    if (productId != null) {
      productController.loadProductDetail(productId);
      productController.loadRelated(productId);
    }

    final brandId = widget.product['brand_id'];
    if (brandId != null) {
      await brandController.fetchBrandById(brandId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final passedData = widget.product;

    // Wrap toàn bộ Scaffold bằng Obx
    return Obx(() {
      // Loading
      if (productController.isLoadingDetail.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final detail = productController.productDetail;
      if (detail.isEmpty) {
        return const Scaffold(
          body: Center(child: Text("Không tải được dữ liệu sản phẩm")),
        );
      }

      final productId = detail['id'];
      final productName = detail['name'] ?? "Unknown Product";
      final productPrice = detail['price']?.toString() ?? "0";
      final productImage = detail['image_url'] ??
          TImages.noImage; // Fallback nếu không có ảnh
      final productStock = detail['stock'] ?? 0;
      final rating =
          double.tryParse(detail['rating_avg']?.toString() ?? "0") ?? 0.0;

      return Scaffold(
        appBar: TAppBar(
          title: Text(productName),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slider ảnh
              ProductImageSlider(images: [productImage]),

              // Thông tin sản phẩm
              ProductInfoSection(
                name: productName,
                price: productPrice,
                rating: rating,
                stock: productStock,
              ),

              // Mô tả sản phẩm
              ProductDescription(description: detail['description'] ?? ""),

              // Thông tin Brand
              Obx(() {
                final sellerName = brandController.brand['name'] ??
                    passedData['brand_name'] ??
                    "Loading...";
                final sellerAvatar = brandController.brand['logo_url'] ??
                    passedData['brand_avatar'] ??
                    TImages.noImage;
                final brandId = passedData['brand_id'] ?? 0;

                return ProductSellerInfo(
                  sellerName: sellerName,
                  sellerAvatar: sellerAvatar,
                  brandId: brandId,
                );
              }),

              // Preview đánh giá
              ProductReviewsPreview(productId: productId),

              // Sản phẩm liên quan
              RelatedProductsSection(
                  relatedProducts: productController.relatedProducts),
            ],
          ),
        ),

        // Bottom bar với wishlist controller
        bottomNavigationBar: ProductBottomBar(
          productId: productId,
          wishlistController: wishlistController,
        ),
      );
    });
  }
}
