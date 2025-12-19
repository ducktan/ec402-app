import 'package:flutter/material.dart';

class TProductTitleText extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final bool smallSize;
  final int maxLines;

  const TProductTitleText({
    super.key,
    required this.title,
    this.textAlign = TextAlign.left,
    this.maxLines = 2,
    this.smallSize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallSize
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}
