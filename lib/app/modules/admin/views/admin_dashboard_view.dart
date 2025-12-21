import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Selamat Datang, Admin!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
            ),
            const SizedBox(height: 10),
            const Text("Apa yang ingin Anda lakukan hari ini?"),
            const SizedBox(height: 30),

            // Menu 1: Tambah Produk
            _buildAdminCard(
              icon: Icons.add_circle_outline,
              title: "Tambah Menu Baru",
              color: Colors.green,
              onTap: () => Get.toNamed(Routes.ADD_PRODUCT),
            ),
            const SizedBox(height: 20),

            // Menu 2: Kelola Produk (Lihat, Edit, Hapus)
            _buildAdminCard(
              icon: Icons.list_alt,
              title: "Kelola Menu (Lihat/Edit/Hapus)",
              color: Colors.orange,
              onTap: () => Get.toNamed(Routes.MANAGE_PRODUCT),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }
}