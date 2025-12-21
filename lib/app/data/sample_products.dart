import '../models/product.dart';

// Ubah ID dari angka (1) menjadi String ("1")
final List<Product> sampleProducts = [
  Product(
    id: "1", // Ubah ke String
    title: 'Cappuccino',
    subtitle: 'Foamy & Rich',
    imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?auto=format&fit=crop&w=600&q=80',
    price: 15000,
  ),
  Product(
    id: "2", // Ubah ke String
    title: 'Matcha Latte',
    subtitle: 'Creamy Green Tea',
    imageUrl: 'https://images.unsplash.com/photo-1727850005779-1e24cac382d4?q=80&w=713&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    price: 20000,
  ),
  // ... Lanjutkan ubah ID ke String untuk item lainnya ...
  Product(
    id: "3",
    title: 'Chocolatte',
    subtitle: 'Sweet Delight',
    imageUrl: 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?auto=format&fit=crop&w=600&q=80',
    price: 15000,
  ),
  // Dan seterusnya... pastikan ID pakai tanda kutip ""
];