class Cart {
  int productId;
  int quantity;
  double price;

  Cart({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory Cart.fromMap(Map<String, dynamic> data) => Cart(
        productId: data['product_id'],
        quantity: data['quantity'],
        price: data['price'],
      );

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'quantity': quantity,
        'price': price,
      };

  Cart copyWith({
    int? productId,
    int? quantity,
    double? price,
  }) {
    return Cart(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}
