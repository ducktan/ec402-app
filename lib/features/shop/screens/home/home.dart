import 'package:ec402_app/common/widgets/appbar/appbar.dart';
import 'package:ec402_app/common/widgets/appbar/primary_header_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:ec402_app/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:ec402_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:ec402_app/common/widgets/products.card/cart_menu_icon.dart';
import 'package:ec402_app/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:ec402_app/utils/constants/colors.dart';
import 'package:ec402_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(child: Column(children: [THomeAppBar()])),
          ],
        ),
      ),
    );
  }
}
