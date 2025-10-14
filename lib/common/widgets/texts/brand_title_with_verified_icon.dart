import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TBrandTitleWithVerifiedIcon extends StatelessWidget {
  const TBrandTitleWithVerifiedIcon({
    super.key,
    required this.title,
    this.textColor = TColors.dark,
    this.iconColor = TColors.primary,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final Color? textColor, iconColor;
  final int maxLines;
  final TextAlign textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    // chọn font size dựa trên enum
    double fontSize;
    switch (brandTextSize) {
      case TextSizes.small:
        fontSize = 12;
        break;
      case TextSizes.medium:
        fontSize = 14;
        break;
      case TextSizes.large:
        fontSize = 16;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            title,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                ),
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Iconsax.verify5,
          color: iconColor,
          size: 16,
        ),
      ],
    );
  }
}
