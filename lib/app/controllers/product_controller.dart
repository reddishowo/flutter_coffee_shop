import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
// Import data lama untuk migrasi awal

class ProductController extends GetxController {
  static ProductController get to => Get.find();
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Observable List Products
  RxList<Product> products = <Product>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // 1. Ambil Data Realtime dari Firestore
  void fetchProducts() {
    _db.collection('products')
       .orderBy('createdAt', descending: true)
       .snapshots()
       .listen((snapshot) {
         products.value = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
         isLoading.value = false;
       });
  }

  // 2. Tambah Produk (Khusus Admin)
  Future<void> addProduct(String title, String subtitle, String imageUrl, int price) async {
  try {
    isLoading.value = true;
    await _db.collection('products').add({
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    });
    Get.snackbar("Sukses", "Menu berhasil ditambahkan", backgroundColor: Colors.green, colorText: Colors.white);
  } catch (e) {
    Get.snackbar("Error", "Gagal menambah menu: $e", backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}

  // 3. Migrasi Data Lama ke Firestore (Sekali jalan saja)
  // Fungsi ini memindahkan data dari sample_products.dart ke Firestore
  Future<void> uploadSampleData() async {
    if (products.isNotEmpty) {
      Get.snackbar("Info", "Data sudah ada di cloud, tidak perlu upload ulang.");
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    final batch = _db.batch();
    
    // Konversi sampleProducts (List lama) ke Firestore
    // Kita anggap sampleProducts di file lama punya struktur yang mirip
    // Note: Anda mungkin perlu sedikit menyesuaikan sample_products.dart agar tidak error tipe datanya
    // atau hardcode ulang listnya disini jika sample_products.dart masih pakai int ID.
    
    // Contoh Hardcode data awal untuk migrasi aman:
    final initialData = [
       {
        'title': 'Cappuccino',
        'subtitle': 'Foamy & Rich',
        'imageUrl': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d',
        'price': 15000,
      },
      {
        'title': 'Matcha Latte',
        'subtitle': 'Creamy Green Tea',
        'imageUrl': 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a',
        'price': 20000,
      },
      // ... tambahkan data lain sesuai kebutuhan
    ];

    for (var item in initialData) {
      var docRef = _db.collection('products').doc(); // Auto ID
      batch.set(docRef, {
        ...item,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    Get.back(); // Tutup loading
    Get.snackbar("Sukses", "Data Sample berhasil diupload ke Firebase!");
  }
  Future<void> updateProduct(String docId, Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      await _db.collection('products').doc(docId).update(data);
      Get.snackbar("Sukses", "Menu berhasil diperbarui");
    } catch (e) {
      Get.snackbar("Error", "Gagal update menu: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 5. Delete Produk
  Future<void> deleteProduct(String docId) async {
    try {
      await _db.collection('products').doc(docId).delete();
      // Tidak perlu refresh manual karena kita pakai snapshots (realtime) di fetchProducts
      Get.snackbar("Sukses", "Menu berhasil dihapus");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus menu: $e");
    }
  }
}