// File: lib/app/modules/menu/views/menu_view.dart

import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../../../data/sample_products.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/app_theme.dart';

class MenuView extends GetView<MenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text('All Menu'), // This will pick up the Serif font from AppTheme
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          itemCount: sampleProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // Adjusts height of the card
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (ctx, i) {
            final product = sampleProducts[i];
            return ProductCard(
              product: product,
              onTap: () {
                Get.toNamed('/product-detail', arguments: product);
              },
            );
          },
        ),
      ),
    );
  }
}