import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';

class PromoView extends StatelessWidget {
  const PromoView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final id = args?['id'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(title: const Text("Promo Spesial! ☕")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.beigeAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.celebration, size: 60, color: AppTheme.brownDark),
              const SizedBox(height: 16),
              const Text(
                "FLASH SALE!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.brownDark),
              ),
              const SizedBox(height: 8),
              Text(
                "Anda mendapatkan penawaran khusus untuk item ID: #$id",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                child: const Text("Ambil Promo"),
              )
            ],
          ),
        ),
      ),
    );
  }
}