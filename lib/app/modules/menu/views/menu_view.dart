// File: lib/app/modules/menu/views/menu_view.dart

import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/product_controller.dart'; // Import controller

class MenuView extends StatelessWidget { // Bisa StatelessWidget karena pake Obx
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: const Text('All Menu')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(() {
          // Cek Loading
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Cek Kosong
          if (productController.products.isEmpty) {
            return const Center(child: Text("Belum ada menu tersedia."));
          }

          return GridView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: productController.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (ctx, i) {
              final product = productController.products[i];
              return ProductCard(
                product: product,
                onTap: () {
                  Get.toNamed('/product-detail', arguments: product);
                },
              );
            },
          );
        }),
      ),
    );
  }
}