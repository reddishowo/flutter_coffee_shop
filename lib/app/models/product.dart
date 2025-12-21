import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id; // Ubah ke String agar cocok dengan ID Firestore
  final String title;
  final String subtitle;
  final String imageUrl;
  final int price;

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
  });

  // Konversi dari Firestore Document ke Object Product
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? 0,
    );
  }

  // Konversi dari Object Product ke Map (untuk upload)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}