import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TVerticalImageText extends StatelessWidget {
  final String? image;
  final IconData? iconData;
  final String title;
  final VoidCallback? onTap;

  const TVerticalImageText({
    super.key,
    this.image,
    this.iconData,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: image != null && image!.isNotEmpty
                ? Image.network(image!, fit: BoxFit.cover)
                : Icon(iconData ?? Iconsax.category, size: 32, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
