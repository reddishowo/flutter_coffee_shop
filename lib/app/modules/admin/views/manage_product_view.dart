import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/product_controller.dart';
import '../../../routes/app_pages.dart';

class ManageProductView extends GetView<ProductController> {
  const ManageProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: const Text("Kelola Menu")),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.products.length,
          itemBuilder: (ctx, i) {
            final product = controller.products[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl, 
                    width: 60, height: 60, fit: BoxFit.cover,
                    errorBuilder: (_,__,___) => Container(color: Colors.grey, width: 60, height: 60, child: const Icon(Icons.error)),
                  ),
                ),
                title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Rp ${product.price}\n${product.subtitle}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TOMBOL EDIT
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Get.toNamed(Routes.EDIT_PRODUCT, arguments: product),
                    ),
                    // TOMBOL DELETE
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(product.id, product.title),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _confirmDelete(String id, String name) {
    Get.defaultDialog(
      title: "Hapus Menu?",
      middleText: "Apakah Anda yakin ingin menghapus $name?",
      textConfirm: "Ya, Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteProduct(id);
        Get.back(); // Tutup Dialog
      },
    );
  }
}