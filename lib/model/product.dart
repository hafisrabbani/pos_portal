class Product {
  int? id;
  final String name;
  final double price;
  final int stockType;
  int? stock;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stockType,
    this.stock,
  });

  factory Product.fromMap(Map<String, dynamic> data) => Product(
    id: data['id'],
    name: data['name'],
    price: data['price'],
    stockType: data['stock_type'],
    stock: data['stock'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'stock_type': stockType,
    'stock': stock,
  };

  Map<String, dynamic> toJson() => toMap();
}