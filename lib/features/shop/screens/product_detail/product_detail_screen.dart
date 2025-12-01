import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final BrandController brandController;
  late final ProductController productController;

  @override
  void initState() {
    super.initState();

    // ✅ Check tồn tại trước khi put, tránh duplicate instance
    brandController = Get.isRegistered<BrandController>()
        ? Get.find<BrandController>()
        : Get.put(BrandController());

    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    _loadData();
  }

  /// Load product detail, related products và brand info
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
    final productId = passedData['id'] ?? 0;

    return Scaffold(
      appBar: TAppBar(
        title: Text(passedData['name'] ?? "Chi tiết sản phẩm"),
        showBackArrow: true,
      ),

      body: Obx(() {
        if (productController.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = productController.productDetail;
        if (detail.isEmpty) {
          return const Center(child: Text("Không tải được dữ liệu sản phẩm"));
        }

        // ===== Prepare data =====
        final productName  = detail['name'] ?? "Unknown Product";
        final productPrice = detail['price']?.toString() ?? "0";
        final productImage = detail['image_url'] ?? "https://via.placeholder.com/300";
        final productStock = detail['stock'] ?? 0;
        final rating       = double.tryParse(detail['rating_avg']?.toString() ?? "0") ?? 0.0;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Slider ảnh
              ProductImageSlider(images: [productImage]),

              /// Thông tin sản phẩm
              ProductInfoSection(
                name: productName,
                price: productPrice,
                rating: rating,
                stock: productStock,
              ),

              /// Mô tả sản phẩm
              ProductDescription(description: detail['description'] ?? ""),

              /// Thông tin Brand
              Obx(() {
                final sellerName =
                    brandController.brand['name'] ??
                    passedData['brand_name'] ??
                    "Loading...";

                final sellerAvatar =
                    brandController.brand['logo_url'] ??
                    passedData['brand_avatar'] ??
                    "https://picsum.photos/200";

                final brandId = passedData['brand_id'] ?? 0;

                return ProductSellerInfo(
                  sellerName: sellerName,
                  sellerAvatar: sellerAvatar,
                  brandId: brandId,
                );
              }),

              /// Preview đánh giá
              ProductReviewsPreview(productId: productId),

              /// Sản phẩm liên quan
              RelatedProductsSection(
                relatedProducts: productController.relatedProducts)
            ],
          ),
        );
      }),

      bottomNavigationBar: const ProductBottomBar(),
    );
  }
}
