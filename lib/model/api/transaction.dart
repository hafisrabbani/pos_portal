class RequestTransaction{
  int orderId;
  int amount;
  int? expiredMintute = 1;

  RequestTransaction({
    required this.orderId,
    required this.amount,
    this.expiredMintute,
  });

  factory RequestTransaction.fromMap(Map<String, dynamic> data) => RequestTransaction(
    orderId: data['order_id'],
    amount: data['amount'],
    expiredMintute: data['expired_minute'],
  );

  Map<String, dynamic> toMap() => {
    'order_id': orderId,
    'amount': amount,
    'expired_minute': expiredMintute,
  };

  Map<String, dynamic> toJson() => toMap();
}

class CreatePayment{
  int orderId;

  CreatePayment({
    required this.orderId,
  });

  factory CreatePayment.fromMap(Map<String, dynamic> data) => CreatePayment(
    orderId: data['order_id'],
  );

  Map<String, dynamic> toMap() => {
    'order_id': orderId,
  };

  Map<String, dynamic> toJson() => toMap();
}


