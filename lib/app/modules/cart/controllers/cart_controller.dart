import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/cart_item.dart';

class CartController extends GetxController {
  late Box<CartItem> cartBox;

  //Hive Keranjang
  @override
  void onInit() {
    super.onInit();
    cartBox = Hive.box<CartItem>('cartBox');
  }

  void deleteItem(CartItem item) {
    item.delete();
  }

  Future<void> sendAllCartToSupabase() async {
    final supabase = Supabase.instance.client;
    final items = cartBox.values.map((item) => {
      'title': item.title,
      'price': item.price,
      'image_url': item.imageUrl,
      'quantity': item.quantity,
    }).toList();

    if (items.isNotEmpty) {
      await supabase.from('cart').insert(items);
      cartBox.clear();
    }
  }
}
