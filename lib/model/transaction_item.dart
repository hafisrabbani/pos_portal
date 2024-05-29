class TransactionItem {
  int? id;
  int? TransactionId;
  int ProductId;
  int Quantity;
  int Price;
  String ProductName;

  TransactionItem({
    this.id,
    this.TransactionId,
    required this.ProductId,
    required this.Quantity,
    required this.Price,
    this.ProductName = '',
  });

  factory TransactionItem.fromMap(Map<String, dynamic> data) => TransactionItem(
        id: data['id'],
        TransactionId: data['transaction_id'],
        ProductId: data['product_id'],
        Quantity: data['quantity'],
        Price: data['price'].toInt(),
        ProductName: data['product_name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'transaction_id': TransactionId,
        'product_id': ProductId,
        'quantity': Quantity,
        'price': Price,
        'product_name': ProductName,
      };

  Map<String, dynamic> toJson() => toMap();
}
