import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_item.dart';

class TransactionDetail{
  final Transaction transaction;
  final List<TransactionItem> items;

  TransactionDetail({required this.transaction, required this.items});

  Map<String, dynamic> toMap() {
    return {
      'transaction': transaction.toMap(),
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory TransactionDetail.fromMap(Map<String, dynamic> map) {
    return TransactionDetail(
      transaction: Transaction.fromMap(map['transaction']),
      items: List<TransactionItem>.from(map['items']?.map((x) => TransactionItem.fromMap(x))),
    );
  }

  Map<String, dynamic> toJson() => toMap();
}