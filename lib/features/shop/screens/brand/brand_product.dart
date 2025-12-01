import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/store/brands/brand_card.dart';
import 'package:ec402_app/common/widgets/products/sortable/sortable_products.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/brand_controller.dart';

class BrandProducts extends StatefulWidget {
  final int brandId;

  const BrandProducts({super.key, required this.brandId});

  @override
  State<BrandProducts> createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  late final BrandController brandCtrl;

  @override
  void initState() {
    super.initState();
    brandCtrl = Get.find<BrandController>();

    // Chỉ gọi API 1 lần khi màn hình được init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Nếu brand đã có cache, lấy từ cache
      if (brandCtrl.brandCache.containsKey(widget.brandId)) {
        brandCtrl.brand.assignAll(brandCtrl.brandCache[widget.brandId]!);
      } else {
        await brandCtrl.fetchBrandById(widget.brandId);
      }

      // Lấy sản phẩm
      await brandCtrl.fetchProducts(widget.brandId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final b = brandCtrl.brand;

      return Scaffold(
        appBar: TAppBar(
          title: Text(b['name'] ?? "Brand"),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                TBrandCard(
                  showBorder: true,
                  brandName: b['name'] ?? "Brand",
                  productCount: brandCtrl.productCount.value.toString(),
                  icon: b['logo_url'],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                if (brandCtrl.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else if (brandCtrl.products.isEmpty)
                  const Center(child: Text("No products found"))
                else
                  TSortableProducts(products: brandCtrl.products),
              ],
            ),
          ),
        ),
      );
    });
  }
}
