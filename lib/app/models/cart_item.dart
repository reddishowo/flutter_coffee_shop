import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  String id; // UBAH DARI int KE String

  @HiveField(1)
  String title;

  @HiveField(2)
  int price;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  String notes;

  @HiveField(6)
  String option; 

  CartItem({
    required this.id, // Pastikan ini String
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.notes = '',
    this.option = 'Hot',
  });
}