import 'package:flutter/material.dart';

class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key,
    required this.title,
    this.textColor,
    this.showActionButton = true,
    this.buttonTiitle = 'See All',
    this.onPressed,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTiitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Popular Categories',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(onPressed: () {}, child: const Text('buttonTitle')),
      ],
    );
  }
}
