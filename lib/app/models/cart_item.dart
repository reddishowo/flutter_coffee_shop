import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  int id;

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
  String option; // "Hot" or "Cool"

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.notes = '',
    this.option = 'Hot',
  });
}