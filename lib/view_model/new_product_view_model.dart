import 'package:pos_portal/data/query/product_query.dart';
import 'package:pos_portal/data/type/product_type.dart';
import 'package:pos_portal/model/product.dart';

class NewProductViewModel {
  Future<List<Product>> loadProducts(ProductType type) async {
    final productQuery = ProductQuery();
    final products = await productQuery.selectWithType(type);
    return products;
  }

  Future<bool> addProduct(Product product) async {
    final productQuery = ProductQuery();
    final success = await productQuery.insert(product.toMap());
    return success;
  }

  Future<bool> updateProduct(Product product) async {
    final productQuery = ProductQuery();
    final success =
        await productQuery.update(product.toMap(), 'id = ?', [product.id]);
    return success;
  }

  Future<bool> deleteProduct(int id) async {
    final productQuery = ProductQuery();
    final success = await productQuery.delete(id);
    return success > 0;
  }

  Future<Product> getProductById(int id) async {
    final productQuery = ProductQuery();
    final productMap = await productQuery.selectBy('id', id);
    return Product.fromMap(productMap);
  }
  Future<bool> importData(List<List<dynamic>> data) async {
    final productQuery = ProductQuery();
    try {
      for (var element in data) {
        print(element[0].toString());
        print(element[1].toString());
        print(element[2].toString());
        print(element[3].toString());

        final product = Product(
          name: element[0].toString(),
          price: double.parse(element[1].toString()),
          stockType: int.parse(element[2].toString()),
          stock: element[3] != null && element[3].toString().isNotEmpty
              ? int.parse(element[3].toString())
              : null,
        );

        await productQuery.insert(product.toMap());
      }
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

}
