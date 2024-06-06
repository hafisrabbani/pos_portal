import 'package:pos_portal/data/query/product_query.dart';
import 'package:pos_portal/data/query/transaction_query.dart';
import 'package:pos_portal/data/type/chart_type.dart';
import 'package:pos_portal/data/type/product_type.dart';

class HomepageViewModel {
  Future<String> getOmsetToday() async {
    final TransactionQuery transactionQuery = TransactionQuery();
    final omset = await transactionQuery.getOmsetToday();
    return omset;
  }

  Future<List<int>> getTransactionCount() async {
    final TransactionQuery transactionQuery = TransactionQuery();
    final ProductQuery productQuery = ProductQuery();
    final transactionCount = await transactionQuery.getTransactionCount();
    final almostOutOfStockCount =
        await productQuery.selectWithType(ProductType.almostOutOfStock);
    final stockCount = await productQuery.sumStock();
    return [almostOutOfStockCount.length, stockCount, transactionCount];
  }

  Future<List<int>> getStatisticTrx(ChartType type) async {
    final TransactionQuery transactionQuery = TransactionQuery();
    final statistik = await transactionQuery.getStatisticTrx(type);
    return statistik;
  }

  void dispose() {
    // Do nothing
  }
}
