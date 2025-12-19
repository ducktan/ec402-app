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
            /// Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF6B00), // cam đậm
                    Color(0xFFFF8C1A), // cam nhạt
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            /// Decorative circles (nhẹ hơn, opacity 0.1)
            Positioned(
              top: -150,
              right: -250,
              child: TCircularContainer(
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: TCircularContainer(
                backgroundColor: Colors.white.withOpacity(0.1),
              ),
            ),

            /// Nội dung child
            Positioned.fill(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
