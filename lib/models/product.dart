import 'package:mobile/models/category.dart';

class Product {
  final int id;
  final String name;
  final double amount;
  final Category category;

  const Product({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      amount: json['amount'] * 1.0,
      category: Category.fromJson(
        json['category'],
      ),
    );
  }
}
