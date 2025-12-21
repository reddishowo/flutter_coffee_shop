import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../widgets/product_card.dart';
// import '../../../data/sample_products.dart'; // HAPUS INI
import '../../../theme/app_theme.dart';
import '../../../controllers/product_controller.dart'; // TAMBAH INI

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil Product Controller untuk data produk
    final productController = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // ... (Bagian TextField Search TETAP SAMA) ...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextField(
                // ... properti textfield tetap ...
                onChanged: (val) => controller.setQuery(val),
              ),
            ),
            
            // Grid Results YANG DIPERBAIKI
            Expanded(
              child: Obx(() {
                // Filter dari ProductController.products (Firebase Data)
                final results = productController.products
                    .where((p) => p.title.toLowerCase().contains(controller.query.value.toLowerCase()))
                    .toList();
                    
                if (results.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.coffee_maker, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Menu not found',
                          style: TextStyle(fontFamily: 'Serif', fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    )
                  );
                }
                
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: results.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (ctx, i) {
                    final p = results[i];
                    return ProductCard(
                      product: p,
                      onTap: () => Get.toNamed('/product-detail', arguments: p),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}