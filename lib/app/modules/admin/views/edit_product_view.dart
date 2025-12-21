import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/product_controller.dart';
import '../../../models/product.dart';

class EditProductView extends StatefulWidget {
  const EditProductView({super.key});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  late Product product;
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController titleC;
  late TextEditingController subtitleC;
  late TextEditingController priceC;
  late TextEditingController imageC;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as Product; // Ambil data dari halaman sebelumnya
    titleC = TextEditingController(text: product.title);
    subtitleC = TextEditingController(text: product.subtitle);
    priceC = TextEditingController(text: product.price.toString());
    imageC = TextEditingController(text: product.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(title: Text("Edit: ${product.title}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput("Nama Produk", titleC),
              const SizedBox(height: 16),
              _buildInput("Deskripsi", subtitleC),
              const SizedBox(height: 16),
              _buildInput("Harga", priceC, isNumber: true),
              const SizedBox(height: 16),
              _buildInput("URL Gambar", imageC),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Update Menu", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      await ProductController.to.updateProduct(product.id, {
        'title': titleC.text,
        'subtitle': subtitleC.text,
        'price': int.tryParse(priceC.text) ?? 0,
        'imageUrl': imageC.text,
      });
      Get.back(); // Kembali ke Manage List
    }
  }
}