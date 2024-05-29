import 'package:pos_portal/data/query/product_query.dart';
import 'package:pos_portal/data/type/product_type.dart';
import 'package:pos_portal/model/product.dart';

class NewProductViewModel{
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
    final success = await productQuery.update(product.toMap(), 'id = ?', [product.id]);
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
}