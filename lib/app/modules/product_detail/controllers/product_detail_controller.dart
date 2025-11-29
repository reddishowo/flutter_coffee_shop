import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../models/cart_item.dart';
import '../../../models/product.dart';

class ProductDetailController extends GetxController {
  void addToCart(Product product) async {
    final box = Hive.box<CartItem>('cartBox');
    CartItem? existing;
    for (var item in box.values) {
      if (item.id == product.id) {
        existing = item;
        break;
      }
    }
    if (existing != null) {
      existing.quantity += 1;
      existing.save();
    } else {
      box.add(CartItem(
        id: product.id,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        quantity: 1,
      ));
    }

    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} ditambahkan ke keranjang!')),
      );
    }
  }
}
