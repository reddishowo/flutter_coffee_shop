import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../../../widgets/product_card.dart';
import '../../../data/sample_products.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Menu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kopi favoritmu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => controller.setQuery(val),
            ),
          ),
          Expanded(
            child: Obx(() {
              final results = sampleProducts
                  .where((p) => p.title.toLowerCase().contains(controller.query.value.toLowerCase()))
                  .toList();
              if (results.isEmpty) {
                return const Center(child: Text('Tidak ada hasil'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
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
    );
  }
}
