import 'package:flutter/material.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:ec402_app/common/widgets/icons/t_circular_icon.dart';
import 'package:ec402_app/common/widgets/images/t_rounded_image.dart';
import 'package:ec402_app/common/widgets/texts/product_price_text.dart';
import 'package:ec402_app/common/widgets/texts/product_title_text.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({
    super.key,
    required this.title,
    required this.price,
    required this.shop,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String price;
  final String shop;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Kiểm tra imageUrl
    Widget buildImage() {
      if (imageUrl.isEmpty) {
        // Không có ảnh
        return const Icon(Icons.image_not_supported, size: 80);
      } else if (imageUrl.startsWith('http')) {
        // URL mạng
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80);
          },
        );
      } else {
        // Asset local
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80);
          },
        );
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Ảnh sản phẩm ---
            TRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: colorScheme.surfaceVariant,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(TSizes.productImageRadius),
                    child: buildImage(),
                  ),
                  // Icon yêu thích
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TCircularIcon(
                      icon: Iconsax.heart5,
                      color: theme.brightness == Brightness.dark
                          ? Colors.redAccent
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwItems / 2),

            // --- Thông tin sản phẩm ---
            Padding(
              padding: const EdgeInsets.only(
                  left: TSizes.sm, right: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: title, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  // Tên shop
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.labelMedium!
                              .copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                      const SizedBox(width: TSizes.xs),
                      Icon(
                        Iconsax.verify,
                        color: colorScheme.primary,
                        size: TSizes.iconXs,
                      ),
                    ],
                  ),

                  const SizedBox(height: TSizes.xs),

                  // Giá + nút thêm vào giỏ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TProductPriceText(price: price, maxLines: 1),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(TSizes.cardRadiusMd),
                            bottomLeft:
                                Radius.circular(TSizes.productImageRadius),
                          ),
                        ),
                        child: const SizedBox(
                          width: TSizes.iconMd,
                          height: TSizes.iconMd,
                          child: Center(
                            child: Icon(Iconsax.add, color: Colors.white),
                          ),
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
  }
}
