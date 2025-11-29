import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../models/cart_item.dart';
import '../../../models/product.dart';

class ProductDetailController extends GetxController {
  var quantity = 1.obs;
  var selectedOption = 'Hot'.obs;
  final TextEditingController noteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    resetState();
  }

  void resetState() {
    quantity.value = 1;
    selectedOption.value = 'Hot';
    noteController.clear();
  }

  void incrementQty() => quantity.value++;
  
  void decrementQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void setOption(String option) {
    selectedOption.value = option;
  }

  void addToCart(Product product) async {
    final box = Hive.box<CartItem>('cartBox');
    
    // Debug print untuk memastikan text ada
    print("Mencoba menambahkan: ${product.title}, Notes: ${noteController.text}");

    CartItem? existing;
    try {
      existing = box.values.firstWhere(
        (item) => item.id == product.id && item.option == selectedOption.value
      );
    } catch (e) {
      existing = null;
    }

    if (existing != null) {
      existing.quantity += quantity.value;
      // Update notes
      if (noteController.text.isNotEmpty) {
         // Jika sudah ada notes, tambahkan koma. Jika belum, isi baru.
        existing.notes = existing.notes.isEmpty 
            ? noteController.text 
            : "${existing.notes}, ${noteController.text}";
      }
      existing.save();
    } else {
      // Item Baru
      final newItem = CartItem(
        id: product.id,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        quantity: quantity.value,
        notes: noteController.text, // Pastikan ini terambil
        option: selectedOption.value,
      );
      box.add(newItem);
    }

    // Tampilkan pesan sukses
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.title} ditambahkan!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
  
  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}