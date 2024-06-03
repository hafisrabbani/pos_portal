import 'package:pos_portal/config/db_config.dart';
import 'package:pos_portal/data/type/transaction_status_type.dart';
import 'package:pos_portal/model/product.dart';
import 'package:pos_portal/model/transaction.dart';
import 'package:pos_portal/model/transaction_item.dart';

class TransactionQuery {
  final DBConfig _dbConfig = DBConfig.instance;

  Future<int> createTrx(Map<String, dynamic> data) async {
    final db = await _dbConfig.database;
    data['created_time'] = DateTime.now().toIso8601String();
    data['updated_time'] = DateTime.now().toIso8601String();
    data['status'] = 0; // set default to pending
    int trxId = await db.insert('Transaction_Record', data);
    return trxId;
  }

  Future<bool> createTrxItem(Map<String, dynamic> data) async {
    final db = await _dbConfig.database;
    data['created_time'] = DateTime.now().toIso8601String();
    data['updated_time'] = DateTime.now().toIso8601String();
    return await db.insert('Transaction_Detail', data) != 0;
  }

  Future<int?> createFullTrx(
      Transaction data, List<TransactionItem> items) async {
    try {
      final db = await _dbConfig.database;
      final trxData = data.toMap();
      trxData['created_time'] = DateTime.now().toIso8601String();
      trxData['updated_time'] = DateTime.now().toIso8601String();
      trxData['status'] = (data.status == TransactionStatusType.paid)
          ? 1
          : ((data.status == TransactionStatusType.failed) ? 2 : 0);
      trxData['payment_method'] = data.paymentMethod.toString().split('.').last;
      print(data.paymentMethod.toString().split('.').last);

      return await db.transaction((txn) async {
        int trxId = await txn.insert('Transaction_Record', trxData);
        if (trxId == 0) return null; // Return null if insert fails
        for (TransactionItem item in items) {
          final itemData = item.toMap();
          itemData['transaction_id'] = trxId;
          itemData['created_time'] = DateTime.now().toIso8601String();
          itemData['updated_time'] = DateTime.now().toIso8601String();
          // unset product_name
          itemData.remove('product_name');
          await txn.insert('Transaction_Detail', itemData);

          // check if type product = 1 (product) then update stock (before it query stock)
          Product product = await txn.query('Product',
              where: 'id = ?',
              whereArgs: [
                item.ProductId
              ]).then((value) => Product.fromMap(value.first));
          print(
              "Product : ${product.name} stockType: ${product.stockType} stock: ${product.stock} item.Quantity: ${item.Quantity}");
          if (product.stockType == 1) {
            product.stock = (product.stock! - item.Quantity);
            await txn.rawQuery('''
              UPDATE Product
              SET stock = ?
              WHERE id = ?
            ''', [product.stock, product.id]);
          }
        }
        return trxId; // Return transaction ID if successful
      }).catchError((error) {
        print('Transaction error: $error');
        return null; // Return null in case of error
      });
    } catch (e) {
      print('Exception caught: $e');
      return null; // Return null in case of exception
    }
  }

  Future<List<Transaction>> selectAll() async {
    final db = await _dbConfig.database;
    // final List<Map<String, dynamic>> result = await db.query('Transaction_Record');
    // order by created_time desc
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT * FROM Transaction_Record tr 
      ORDER BY tr.created_time DESC
    ''');
    return result.map((row) => Transaction.fromMap(row)).toList();
  }

  Future<bool> updateStatusPayment(int id, TransactionStatusType status) async {
    final db = await _dbConfig.database;
    int statusIndex = 0;
    switch (status) {
      case TransactionStatusType.paid:
        statusIndex = 1;
        break;
      case TransactionStatusType.failed:
        statusIndex = 2;
        break;
      default:
        statusIndex = 0;
    }

    return await db.rawUpdate('''
      UPDATE Transaction_Record
      SET status = ?
      WHERE id = ?
    ''', [statusIndex, id]) != 0;
  }

  Future<List<TransactionItem>> selectTrxItem(int trxId) async {
    final db = await _dbConfig.database;
    // final List<Map<String, dynamic>> result = await db.query('Transaction_Detail', where: 'transaction_id = ?', whereArgs: [trxId]);
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT td.id, td.transaction_id, td.product_id, td.quantity, td.price, p.name as product_name
      FROM Transaction_Detail td
      JOIN Product p ON td.product_id = p.id
      WHERE td.transaction_id = ?
    ''', [trxId]);

    return result.map((row) => TransactionItem.fromMap(row)).toList();
  }

  Future<Transaction> selectById(int id) async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result =
        await db.query('Transaction_Record', where: 'id = ?', whereArgs: [id]);
    print(result);
    return Transaction.fromMap(result.first);
  }

  Future<String> getOmsetToday() async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(td.price * td.quantity) as omset
      FROM Transaction_Detail td
      JOIN Transaction_Record tr ON td.transaction_id = tr.id
      WHERE tr.created_time >= date('now')
    ''');
    return result.first['omset'].toString();
  }

  Future<int> getTransactionCount() async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COUNT(*) as trx_count
      FROM Transaction_Record
    ''');
    return result.first['trx_count'];
  }
}
