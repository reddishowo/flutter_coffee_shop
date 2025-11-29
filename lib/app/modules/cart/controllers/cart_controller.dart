import 'dart:math'; // Import for random number generation
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/cart_item.dart';
import '../../../theme/app_theme.dart';

class CartController extends GetxController {
  late Box<CartItem> cartBox;

  @override
  void onInit() {
    super.onInit();
    cartBox = Hive.box<CartItem>('cartBox');
  }

  void incrementItem(CartItem item) {
    item.quantity++;
    item.save();
  }

  void decrementItem(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      item.save();
    } else {
      deleteItem(item);
    }
  }

  void deleteItem(CartItem item) {
    item.delete();
  }

  double get totalPrice {
    double total = 0;
    for (var item in cartBox.values) {
      total += (item.price * item.quantity);
    }
    return total;
  }

  void showPaymentModal() {
    // --- 1. FIXED: Replaced Get.rawSnackbar with ScaffoldMessenger ---
    if (cartBox.isEmpty) {
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Keranjang kosong, pilih menu dulu ya!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final context = Get.context;
    if (context == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.qr_code, color: AppTheme.brownDark),
              title: const Text("QRIS"),
              onTap: () => _processPayment("QRIS"),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.money, color: Colors.green),
              title: const Text("Tunai"),
              onTap: () => _processPayment("Tunai"),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(String method) {
    Navigator.pop(Get.context!); // Close BottomSheet

    // Show Loading
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pop(Get.context!); // Close Loading
      
      final random = Random();
      final orderId = "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}-${random.nextInt(999)}";

      await _sendToSupabase(orderId);
      await cartBox.clear();

      if (Get.context != null) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false, // User must click OK
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pesanan Berhasil!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 10),
                const Text("Tunjukkan kode ini ke kasir:", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                
                const SizedBox(height: 20),
                
                // Simulated QR Code Display
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12)
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2, size: 100, color: Colors.black87), // Fake QR
                      const SizedBox(height: 8),
                      Text(
                        orderId, 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Text("Metode: $method", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brownDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  onPressed: () {
                    Navigator.pop(Get.context!); // Close Dialog
                    Get.back(); // Go back to Home/Menu
                  },
                  child: const Text("Selesai"),
                ),
              )
            ],
          ),
        );
      }
    });
  }

  Future<void> _sendToSupabase(String orderId) async {
    try {
      final supabase = Supabase.instance.client;
      final items = cartBox.values.map((item) => {
        'title': item.title,
        'price': item.price,
        'image_url': item.imageUrl,
        'quantity': item.quantity,
        'notes': item.notes,
        'option': item.option,
        'order_id': orderId, // We assume you might want to save this ID too
        'created_at': DateTime.now().toIso8601String(),
      }).toList();

      if (items.isNotEmpty) {
        // If your Supabase table doesn't have 'order_id' column, this might error.
        // You can remove the 'order_id' line above if you haven't updated Supabase schema.
        await supabase.from('cart').insert(items);
      }
    } catch (e) {
      print("Supabase error: $e");
    }
  }
}