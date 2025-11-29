import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_detail_controller.dart';
import '../../../models/product.dart';
import '../../../theme/app_theme.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  final Product product;
  
  ProductDetailView({Product? product, super.key}) 
      : product = product ?? Get.arguments as Product;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Biarkan naik saat keyboard muncul
      body: Stack(
        children: [
          // Gambar Background
          Positioned(
            top: 0, left: 0, right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.network(product.imageUrl, fit: BoxFit.cover),
          ),
          
          // Tombol Back
          Positioned(
            top: 40, left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Konten
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView( // Tambah Scroll agar tidak overflow saat keyboard muncul
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Dibuat dengan bahan premium, menghadirkan rasa yang lembut.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    
                    // Input Notes
                    const Text("Catatan Tambahan", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.noteController,
                      decoration: InputDecoration(
                        hintText: "Contoh: Less Sugar, Extra Ice...",
                        filled: true,
                        fillColor: AppTheme.beigeAccent.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pilihan Suhu
                    const Text("Pilih Suhu", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Obx(() => Row(
                      children: [
                        _OptionChip(
                          label: "Cool", 
                          isSelected: controller.selectedOption.value == 'Cool',
                          onTap: () => controller.setOption('Cool'),
                        ),
                        const SizedBox(width: 12),
                        _OptionChip(
                          label: "Hot", 
                          isSelected: controller.selectedOption.value == 'Hot',
                          onTap: () => controller.setOption('Hot'),
                        ),
                      ],
                    )),

                    const SizedBox(height: 30),

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
                              IconButton(
                                onPressed: controller.decrementQty, 
                                icon: const Icon(Icons.remove, size: 18)
                              ),
                              Obx(() => Text(
                                "${controller.quantity.value}", 
                                style: const TextStyle(fontWeight: FontWeight.bold)
                              )),
                              IconButton(
                                onPressed: controller.incrementQty, 
                                icon: const Icon(Icons.add, size: 18)
                              ),
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
                            child: const Text("Masuk Keranjang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    // Space for bottom safe area
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 300 : 20), 
                  ],
                ),
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
  final VoidCallback onTap;

  const _OptionChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.brownDark : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}