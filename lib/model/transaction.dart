import 'package:pos_portal/data/type/payment_method_type.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';

class Transaction {
  int? id;
  int NominalPayment;
  int TotalPayment;
  int Change;
  PaymentMethodType paymentMethod = PaymentMethodType.CASH;
  TransactionStatusType status = TransactionStatusType.pending;
  String? CreatedTime;
  Transaction({
    this.id,
    required this.NominalPayment,
    required this.TotalPayment,
    required this.Change,
    required this.status,
    this.paymentMethod = PaymentMethodType.CASH,
    this.CreatedTime,
  });

  factory Transaction.fromMap(Map<String, dynamic> data) {
    return Transaction(
      id: data['id'],
      NominalPayment: (data['nominal_payment'] is double)
          ? data['nominal_payment'].toInt()
          : int.parse(data['nominal_payment']),
      TotalPayment: (data['total'] is double)
          ? data['total'].toInt()
          : int.parse(data['total']),
      Change: (data['change'] is double)
          ? data['change'].toInt()
          : int.parse(data['change']),
      status: TransactionStatusType.values[data['status']],
      paymentMethod: PaymentMethodType.values.byName(data['payment_method']),
      CreatedTime: data['created_time'],
    );
  }


  Map<String, dynamic> toMap() => {
    'id': id,
    'nominal_payment': NominalPayment,
    'total': TotalPayment,
    'change': Change,
    'status': status.index,
    'payment_method': paymentMethod.index,
    'created_time': CreatedTime,
  };

  Map<String, dynamic> toJson() => toMap();
}
