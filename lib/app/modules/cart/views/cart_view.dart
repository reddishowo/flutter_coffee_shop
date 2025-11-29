// File: /coffeeshopmobileapp/lib/app/modules/cart/views/cart_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../theme/app_theme.dart';
import '../controllers/cart_controller.dart';
import '../../../models/cart_item.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Konfirmasi Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller.cartBox.listenable(),
              builder: (context, Box<CartItem> box, _) {
                if (box.isEmpty) return const Center(child: Text("Keranjang Kosong"));
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: box.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, index) {
                    final item = box.getAt(index);
                    if (item == null) return const SizedBox();
                    
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Detail
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text("Rp ${item.price}", style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(Icons.edit, size: 14, color: Colors.grey),
                                  Text(" Low Sugar, Cool", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              )
                            ],
                          ),
                        ),
                        // Counter
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {/* logic kurang */},
                                  child: const Icon(Icons.remove_circle_outline, size: 20),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                InkWell(
                                  onTap: () {/* logic tambah */},
                                  child: const Icon(Icons.add_circle_outline, size: 20),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
          
          // Bottom Area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Total", style: TextStyle(fontSize: 14)),
                    Text("Rp 30.000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logic Pesan / Kirim ke Supabase
                    controller.sendAllCartToSupabase();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.beigeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Pesan", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}