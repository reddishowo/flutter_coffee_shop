// File: /coffeeshopmobileapp/lib/app/modules/account/views/account_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/account_controller.dart';
import '../../../theme/app_theme.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Foto Profil
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=9'), // Ganti foto sesuai keinginan
              ),
              const SizedBox(height: 20),

              // Kotak Informasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.beigeAccent, // Warna krem/peach
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _InfoRow(label: "Name", value: "Salsa"),
                    SizedBox(height: 16),
                    _InfoRow(label: "Email", value: "salsa@gmail.com"),
                    SizedBox(height: 16),
                    _InfoRow(label: "Phone Number", value: "0812345678"),
                    SizedBox(height: 16),
                    _InfoRow(label: "Birth Date", value: "12 - 10 - 2006"),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),

              // Tombol Log Out
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.beigeAccent,
                    elevation: 0,
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}