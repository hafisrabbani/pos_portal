class ItemCart{
  int productId;
  String name;
  int price;
  int quantity;

  ItemCart({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory ItemCart.fromMap(Map<String, dynamic> data) => ItemCart(
    productId: data['product_id'],
    name: data['name'],
    price: data['price'],
    quantity: data['quantity'],
  );

  Map<String, dynamic> toMap() => {
    'product_id': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
  };

  ItemCart copyWith({
    int? productId,
    String? name,
    int? price,
    int? quantity,
  }) {
    return ItemCart(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}