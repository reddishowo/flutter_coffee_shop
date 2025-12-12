import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';

// --- Simple Model for History ---
class OrderHistoryItem {
  final String id;
  final String date;
  final String itemName;
  final String imageUrl;
  final int total;
  final String status; // 'Completed', 'Canceled', 'On Process'

  OrderHistoryItem(this.id, this.date, this.itemName, this.imageUrl, this.total, this.status);
}

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<OrderHistoryItem> orders = [
      OrderHistoryItem("ORD-8821", "2023-10-24 14:30", "Cappuccino & Croissant", "https://images.unsplash.com/photo-1572442388796-11668a67e53d", 45000, "On Process"),
      OrderHistoryItem("ORD-1102", "2023-10-20 09:15", "Americano (Hot)", "https://images.unsplash.com/photo-1551024601-bec0273e132e", 15000, "Completed"),
      OrderHistoryItem("ORD-0922", "2023-10-18 16:45", "Matcha Latte", "https://unsplash.com/photos/white-ceramic-teacup-filled-of-matcha-tea-Z-hvocTfR_s", 20000, "Completed"),
      OrderHistoryItem("ORD-0012", "2023-10-15 12:00", "Boba Brown Sugar", "https://images.unsplash.com/photo-1525695239455-cd27a2d0409d", 25000, "Canceled"),
    ];

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text("Order History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 16),
        itemBuilder: (ctx, i) {
          final order = orders[i];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderHistoryItem order) {
    Color statusColor;
    switch(order.status) {
      case 'Completed': statusColor = Colors.green; break;
      case 'Canceled': statusColor = Colors.red; break;
      default: statusColor = Colors.orange;
    }

    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          // Header: Date & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              )
            ],
          ),
          const Divider(height: 24),
          
          // Body: Image & Details
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  order.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_,__,___) => Container(color: Colors.grey[300], width: 60, height: 60),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.itemName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Serif'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.id,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Footer: Price & Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Price", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(
                    currency.format(order.total),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brownDark, fontSize: 16),
                  ),
                ],
              ),
              if (order.status == 'Completed')
                OutlinedButton(
                  onPressed: () {
                    // Logic to re-add to cart
                    Get.snackbar("Added", "Items added to cart");
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.brownDark),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Reorder", style: TextStyle(color: AppTheme.brownDark)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}