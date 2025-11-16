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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: colorScheme.surface, // theo theme
        ),
        child: Column(
          children: [
            // --- Ảnh sản phẩm ---
            TRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: colorScheme.surfaceVariant, // theme-aware
              child: Stack(
                children: [
                  TRoundedImage(
                    imageUrl: imageUrl.isNotEmpty ? imageUrl : '',
                    applyImageRadius: true,
                  ),

                  // Giảm giá (nếu cần, demo 25%)
                  Positioned(
                    top: 12,
                    child: TRoundedContainer(
                      radius: TSizes.sm,
                      backgroundColor: colorScheme.secondary.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs,
                      ),
                      child: Text(
                        '25%',
                        style: theme.textTheme.labelLarge!
                            .copyWith(color: colorScheme.onSecondary),
                      ),
                    ),
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
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: title, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  // Tên shop
                  Row(
                    children: [
                      Flexible(
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

                  // Giá + nút thêm vào giỏ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TProductPriceText(price: price),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(TSizes.cardRadiusMd),
                            bottomLeft: Radius.circular(TSizes.productImageRadius),
                          ),
                        ),
                        child: const SizedBox(
                          width: TSizes.iconMd,
                          height: TSizes.iconMd,
                          child: Center(
                            child: Icon(
                              Iconsax.add,
                              color: Colors.white,
                            ),
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
