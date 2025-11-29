// File: /coffeeshopmobileapp/lib/app/modules/home_tab/views/home_tab_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_tab_controller.dart';
import '../../../data/sample_products.dart';
import '../../../widgets/product_card.dart';

class HomeTabView extends GetView<HomeTabController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black87),
                  const SizedBox(width: 8),
                  const Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner Promo
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C1A06), // Warna banner gelap
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&w=800&q=60'),
                          fit: BoxFit.cover,
                          opacity: 0.4, // Supaya tulisan terbaca
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 20,
                            top: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("DISC", style: TextStyle(color: Colors.white, fontSize: 16)),
                                const Text("40%", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: Colors.white,
                                  child: const Text("25rb /cup", style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Grid Produk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(), // Scroll ikut parent
                        shrinkWrap: true,
                        itemCount: sampleProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}