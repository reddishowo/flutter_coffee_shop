import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_tab_controller.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/product_controller.dart'; // TAMBAH INI

class HomeTabView extends GetView<HomeTabController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ProductController
    final productController = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ... (Bagian Search Bar & Banner Header TETAP SAMA, tidak perlu diubah) ...
            const SizedBox(height: 10),
            // ... Code Search Bar ...
            // ... Code Location Header ...
            // ... Code Promo Banner ...
            
            // --- GANTI BAGIAN GRID DI BAWAH INI ---
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ... (Code Search & Banner diatasnya tetap) ...
                      
                      const SizedBox(height: 25),
                      const Text(
                        "Recommendation",
                        style: TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold, 
                          color: AppTheme.brownDark,
                          fontFamily: 'Serif'
                        ),
                      ),
                      const SizedBox(height: 15),

                      // GRIDVIEW YANG DIPERBAIKI (MENGGUNAKAN FIREBASE)
                      Obx(() {
                        if (productController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (productController.products.isEmpty) {
                          return const Text("No products available.");
                        }

                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productController.products.length, // Pakai data controller
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
                              onTap: () => Get.toNamed('/product-detail', arguments: product),
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}