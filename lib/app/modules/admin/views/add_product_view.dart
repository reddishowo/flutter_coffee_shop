// File: lib/app/modules/admin/views/add_product_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/product_controller.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller Text
  final TextEditingController titleC = TextEditingController();
  final TextEditingController subtitleC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController imageC = TextEditingController();
  
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text("Admin: Tambah Menu"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Isi detail produk kopi baru:", style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),
              
              _buildInput("Nama Produk", "Contoh: Caramel Latte", titleC, Icons.coffee),
              const SizedBox(height: 16),
              _buildInput("Deskripsi Singkat", "Contoh: Sweet & Creamy", subtitleC, Icons.short_text),
              const SizedBox(height: 16),
              _buildInput("Harga (Rp)", "Contoh: 25000", priceC, Icons.attach_money, isNumber: true),
              const SizedBox(height: 16),
              _buildInput("URL Gambar", "https://...", imageC, Icons.image),
              const SizedBox(height: 8),
              const Text("Tips: Gunakan link gambar dari Unsplash", style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitProduct, // Panggil fungsi _submitProduct
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brownDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("Simpan Produk", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.brownDark),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  // --- LOGIKA UTAMA DISINI ---
  void _submitProduct() async {
    // 1. Validasi Form
    if (_formKey.currentState!.validate()) {
      
      // 2. Mulai Loading
      setState(() => isLoading = true);
      
      try {
        final price = int.tryParse(priceC.text) ?? 0;
        
        // 3. Panggil Controller (Tunggu sampai selesai / await)
        // Kita tidak ingin controller melakukan navigasi, jadi biarkan view yang handle
        await ProductController.to.addProduct(
          titleC.text, 
          subtitleC.text, 
          imageC.text, 
          price
        );

        // 4. Stop Loading
        setState(() => isLoading = false);

        // 5. TAMPILKAN MODAL SUKSES (PENTING: Jangan Get.back dulu!)
        if (mounted) {
          _showSuccessModal();
        }

      } catch (e) {
        // Jika error
        setState(() => isLoading = false);
        Get.snackbar("Gagal", "Terjadi kesalahan: $e", backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  void _showSuccessModal() {
    Get.defaultDialog(
      title: "Berhasil!",
      titleStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
      content: Column(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
          const SizedBox(height: 10),
          Text(
            "Menu '${titleC.text}' berhasil ditambahkan.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      // Tombol OK
      confirm: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brownDark),
          onPressed: () {
            Get.back(); // 1. Tutup Dialog Modal
            Get.back(); // 2. Tutup Halaman Add Product (Kembali ke Dashboard)
          },
          child: const Text("OK", style: TextStyle(color: Colors.white)),
        ),
      ),
      barrierDismissible: false, // User wajib klik OK
      radius: 15,
      contentPadding: const EdgeInsets.all(20),
    );
  }
}