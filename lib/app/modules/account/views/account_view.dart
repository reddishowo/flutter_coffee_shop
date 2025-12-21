// File: /lib/app/modules/account/views/account_view.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController()); 
    final auth = AuthService.to; 

    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 1. Profile Header
              Obx(() {
                final user = auth.userData;
                // Ambil path lokal
                String localPath = auth.localProfilePath.value;
                
                ImageProvider imageProvider;
                if (localPath.isNotEmpty && File(localPath).existsSync()) {
                   // Prioritas 1: Gambar Lokal
                   imageProvider = FileImage(File(localPath));
                } else {
                   // Prioritas 2: Gambar Firebase / Default
                   imageProvider = NetworkImage(user['photoUrl'] ?? 'https://i.pravatar.cc/150?img=5');
                }

                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: imageProvider, // Gunakan provider dinamis
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user['name'] ?? "Guest", 
                      style: const TextStyle(fontSize: 22, fontFamily: 'Serif', fontWeight: FontWeight.bold)
                    ),
                    Text(
                      user['email'] ?? "", 
                      style: const TextStyle(color: Colors.grey)
                    ),
                  ],
                );
              }),
              
              const SizedBox(height: 30),

              // 2. WEATHER WIDGET (Tetap sama)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.brownDark, AppTheme.brownCard],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Obx(() {
                  if (controller.isWeatherLoading.value) {
                    return const Center(child: Padding(padding: EdgeInsets.all(20.0),child: CircularProgressIndicator(color: Colors.white)));
                  }
                  if (controller.isWeatherError.value) {
                    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Weather unavailable", style: TextStyle(color: Colors.white)), IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: controller.fetchWeather)]);
                  }
                  final temp = controller.weatherTemp.value;
                  final isHot = temp > 25;
                  return Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Today's Vibe in ${controller.locationName.value}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text("${temp.toStringAsFixed(1)}°C", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(isHot ? "Stay Cool with Iced Coffee! 🧊" : "Warm up with Hot Coffee ☕", style: const TextStyle(color: AppTheme.beigeAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Icon(isHot ? Icons.wb_sunny : Icons.cloud, color: Colors.white.withOpacity(0.9), size: 50),
                        ],
                      ),
                      Positioned(top: -12, right: -12, child: IconButton(icon: const Icon(Icons.refresh, color: Colors.white54, size: 20), tooltip: "Reload Weather", onPressed: controller.fetchWeather)),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 3. SETTINGS LIST
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // --- ADMIN SECTION (Hanya muncul jika Role == 'admin') ---
                    Obx(() {
                      if (auth.userData['role'] == 'admin') {
                        return Column(
                          children: [
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.admin_panel_settings, color: Colors.deepOrange),
                              ),
                              title: const Text("Admin Panel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                              subtitle: const Text("Tambah Menu Produk Baru", style: TextStyle(fontSize: 12)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepOrange),
                              onTap: () => Get.toNamed(Routes.ADMIN_DASHBOARD),
                            ),
                            const Divider(height: 1, thickness: 1),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    // --------------------------------------------------------

                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                      onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.storefront,
                      title: "Find Our Store",
                      subtitle: "Visit us at Jl. Besar Ijen",
                      onTap: () => Get.toNamed(Routes.LOCATION_EXPERIMENT),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: "Order History",
                      onTap: () => Get.toNamed(Routes.ORDER_HISTORY),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => auth.logout(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon, 
    required String title, 
    String? subtitle, 
    required VoidCallback onTap
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.creamBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.brownDark),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}