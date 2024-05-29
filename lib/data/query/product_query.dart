import '../../config/db_config.dart';
import '../../model/product.dart';
import '../type/product_type.dart';

class ProductQuery {
  final DBConfig _dbConfig = DBConfig.instance;

  Future<List<Product>> selectAll() async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.query('Product');
    return result.map((row) => Product.fromMap(row)).toList();
  }

  Future<bool> insert(Map<String, dynamic> data) async {
    final db = await _dbConfig.database;
    data['created_time'] = DateTime.now().toIso8601String();
    data['updated_time'] = DateTime.now().toIso8601String();
    return await db.insert('Product', data) != 0;
  }

  Future<bool> update(Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    final db = await _dbConfig.database;
    return await db.update('Product', data, where: where, whereArgs: whereArgs) != 0;
  }

  Future<int> delete(int id) async {
    final db = await _dbConfig.database;
    return await db.delete('Product', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> selectWhere(String where, List<dynamic> whereArgs) async {
    final db = await _dbConfig.database;
    return await db.query('Product', where: where, whereArgs: whereArgs);
  }

  Future<Map<String, dynamic>> selectBy(String column, dynamic value) async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.query('Product', where: '$column = ?', whereArgs: [value]);
    return result.first;
  }


  Future<List<Product>> selectWithType(ProductType type) async {
    final db = await _dbConfig.database;
    switch(type){
      case ProductType.all:
        final List<Map<String, dynamic>> result = await db.query('Product');
        return result.map((row) => Product.fromMap(row)).toList();
      case ProductType.almostOutOfStock:
        print("Query almost out of stock");
        final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM Product WHERE stock <= 3 AND stock_type = 1');
        print("Almost out of stock result: $result");
        return result.map((row) => Product.fromMap(row)).toList();
      case ProductType.bestSeller:
        final List<Map<String, dynamic>> result = await db.rawQuery('''
          SELECT p.*
          FROM Product p
          JOIN Transaction_Detail td ON p.id = td.product_id
          GROUP BY p.id
          ORDER BY SUM(td.quantity) DESC
          LIMIT 10
        ''');
        return result.map((row) => Product.fromMap(row)).toList();
      default:
        final List<Map<String, dynamic>> result = await db.query('Product');
        return result.map((row) => Product.fromMap(row)).toList();
    }
  }

  Future<int> getAlmostOutOfStock() async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.query('Product', where: 'stock <= 3 AND stock_type = 1');
    return result.length;
  }

  Future<int> sumStock() async {
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(stock) as total FROM Product WHERE stock_type = 1');
    return result.first['total'];
  }

  Future<int> getTotalTrx() async{
    final db = await _dbConfig.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as total FROM Transaction_Record');
    return result.first['total'];
  }
}