class Order {
  final int id;
  final int userId;
  final String transactionReference;
  final String createdAt;
  final String productName;
  final double amountPaid;

  const Order({
    required this.id,
    required this.userId,
    required this.transactionReference,
    required this.createdAt,
    required this.productName,
    required this.amountPaid,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      transactionReference: json['transaction_reference'],
      createdAt: json['created_at'],
      productName: json['product_name'],
      amountPaid: json['amount_paid'] + 1.0,
    );
  }
}
