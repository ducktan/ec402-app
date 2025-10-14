import 'package:ec402_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
    this.height = 400,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TcurvedEdgeWidget(
      child: SizedBox(
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// Background color
            Container(color: TColors.primary),

            /// Decorative circles
            Positioned(
              top: -150,
              right: -250,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TCircularContainer(
                backgroundColor: TColors.textWhite.withValues(alpha: 0.1),
              ),
            ),

            /// 🔹 Đảm bảo nội dung nằm trên cùng và nhận gesture
            Positioned.fill(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}