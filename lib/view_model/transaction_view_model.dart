import 'package:pos_portal/data/hooks/qris_service.dart';
import 'package:pos_portal/data/query/transaction_query.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/model/api/resp_transaction.dart';
import 'package:pos_portal/model/api/transaction.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_detail.dart';
import 'package:pos_portal/model/transaction_item.dart';
class TransactionViewModel{
  Future<int?> createTrx(Transaction data, List<TransactionItem> items) async {
    final TransactionQuery transactionQuery = TransactionQuery();
    int? result = await transactionQuery.createFullTrx(data, items);
    return result;
  }

  Future<List<Transaction>> getAll() async {
    final TransactionQuery transactionQuery = TransactionQuery();
    List<Transaction> result = await transactionQuery.selectAll();
    return result;
  }

  Future<Transaction> getById(int id) async {
    final TransactionQuery transactionQuery = TransactionQuery();
    Transaction result = await transactionQuery.selectById(id);
    return result;
  }

  Future<TransactionDetail> getTransactionDetails(int id) async {
    final TransactionQuery transactionQuery = TransactionQuery();
    Transaction transaction = await transactionQuery.selectById(id);
    List<TransactionItem> items = await transactionQuery.selectTrxItem(id);
    return TransactionDetail(transaction: transaction, items: items);
  }

  Future<bool> updatePayment(int id, TransactionStatusType status) async{
    final TransactionQuery transactionQuery = TransactionQuery();
    bool result = await transactionQuery.updateStatusPayment(id, status);
    return result;
  }

  Future<RespPayment> createPaymentQris(RequestTransaction data){
    final QrisService qrisService = QrisService();
    return qrisService.createQris(data);
  }
}
