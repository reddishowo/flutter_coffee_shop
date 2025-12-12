// File: lib/app/modules/home_tab/views/home_tab_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_tab_controller.dart';
import '../../../data/sample_products.dart';
import '../../../widgets/product_card.dart';
import '../../../theme/app_theme.dart';

class HomeTabView extends GetView<HomeTabController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // --- 1. SEARCH BAR (Peach Color) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  // Switch to Search Tab (Index 2 in HomeController)
                  // Get.find<GetxController>(tag: 'home_controller').update(); 
                  // Or navigate directly if you prefer: 
                  Get.toNamed('/search');
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppTheme.peachSearch, // The specific Peach color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.black87, size: 28),
                      SizedBox(width: 15),
                      Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontFamily: 'Serif', // Matching font
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- 2. MAIN CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      
                      // Location Header
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: AppTheme.brownDark, size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Malang, Indonesia", 
                            style: TextStyle(
                              color: Colors.grey, 
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                            )
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),

                      // Promo Banner (Improved Design)
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=800&q=60'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,5))
                          ]
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Get 20% Off\nFirst Order", 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontFamily: 'Serif', 
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppTheme.peachSearch,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Promo Code: COFFEE20", 
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      
                      // Section Title
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

                      // Product Grid
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sampleProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (ctx, i) {
                          return ProductCard(
                            product: sampleProducts[i],
                            onTap: () => Get.toNamed('/product-detail', arguments: sampleProducts[i]),
                          );
                        },
                      ),
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