// File: lib/app/modules/search/views/search_view.dart

import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../widgets/product_card.dart';
import '../../../data/sample_products.dart';
import '../../../theme/app_theme.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Real Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextField(
                autofocus: false,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search coffee...',
                  hintStyle: const TextStyle(fontFamily: 'Serif', color: Colors.black45),
                  prefixIcon: const Icon(Icons.search, color: Colors.black87, size: 28),
                  filled: true,
                  fillColor: AppTheme.peachSearch, // Peach background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none, 
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (val) => controller.setQuery(val),
              ),
            ),
            
            // Grid Results
            Expanded(
              child: Obx(() {
                final results = sampleProducts
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