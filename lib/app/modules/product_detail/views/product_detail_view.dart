// File: /coffeeshopmobileapp/lib/app/modules/product_detail/views/product_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import '../../../models/product.dart';
import '../../../theme/app_theme.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  final Product product;
  // Menggunakan Get.arguments jika product tidak di-pass via constructor
  ProductDetailView({Product? product, super.key}) 
      : product = product ?? Get.arguments as Product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sesuaikan dengan warna atas gambar
      body: Stack(
        children: [
          // Gambar Background Full di atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          
          // Tombol Back
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Konten Putih di Bawah
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Dibuat dengan bahan premium, menghadirkan rasa yang lembut dan aroma yang menenangkan.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  
                  // Catatan Tambahan
                  const Text("Catatan Tambahan", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Low Sugar",
                      filled: true,
                      fillColor: AppTheme.beigeAccent.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Opsi Cool / Hot
                  Row(
                    children: [
                      _OptionChip(label: "Cool", isSelected: false),
                      const SizedBox(width: 12),
                      _OptionChip(label: "Hot", isSelected: true),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Bar (Qty & Button)
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.beigeAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.remove, size: 18)),
                            const Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.add, size: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.addToCart(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.beigeAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Keranjang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _OptionChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.beigeAccent : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}