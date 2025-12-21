import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Injeksi Controller
    final controller = Get.put(OrderHistoryController());
    
    // Formatter Rupiah
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // State Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // State Kosong
        if (controller.orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text("Belum ada riwayat pesanan", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // State Ada Data
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.orders.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 20),
          itemBuilder: (ctx, i) {
            final doc = controller.orders[i];
            final data = doc.data() as Map<String, dynamic>;

            // Parsing Data
            final String orderId = data['orderId'] ?? 'Unknown';
            final double total = (data['totalPrice'] ?? 0).toDouble();
            final List<dynamic> items = data['items'] ?? [];
            final String paymentMethod = data['paymentMethod'] ?? '-';
            
            // Format Tanggal
            String dateStr = "";
            if (data['createdAt'] != null) {
              Timestamp t = data['createdAt'];
              dateStr = DateFormat('dd MMM yyyy, HH:mm').format(t.toDate());
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER KARTU (ID & Tanggal) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderId,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        dateStr,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // --- LIST ITEM MENU ---
                  // Menampilkan setiap menu yang dipesan
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar Item
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['imageUrl'] ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (_,__,___) => Container(
                                  width: 50, height: 50, color: Colors.grey[200],
                                  child: const Icon(Icons.coffee, size: 20, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // Detail Item
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? 'Menu',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    "${item['quantity']}x @ ${currency.format(item['price'])} • ${item['option']}",
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  // Tampilkan Notes jika ada
                                  if (item['notes'] != null && item['notes'].toString().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        "Catatan: ${item['notes']}",
                                        style: const TextStyle(fontSize: 11, color: AppTheme.brownDark, fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  // --- FOOTER KARTU (Metode & Total) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Metode Bayar", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text("Total Bayar", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text(
                            currency.format(total),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: AppTheme.brownDark, 
                              fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}