import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/type/product_type.dart';
import '../model/product.dart';
import '../data/query/product_query.dart';

class ProductViewModel extends ChangeNotifier {
  static const String _productsKey = 'products';
  static const String _selectedTypeKey = 'selectedType';
  static const String _selectedProductIdKey = 'selectedProductId';
  SharedPreferences? _prefs;
  List<Product> _products = [];
  int _selectedProductId = 0;
  ProductType _selectedType = ProductType.all;
  final ValueNotifier<List<Product>> productsNotifier = ValueNotifier([]);

  ProductType get selectedType => _selectedType;
  int get selectedProductId => _selectedProductId;

  ProductViewModel() {
    _init();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSelectedType();
    _loadProducts();
    _loadSelectedProductId();
  }

  int getSelectedProductId() {
    return _prefs?.getInt(_selectedProductIdKey) ?? 0;
  }

  void _loadSelectedType() {
    final selectedTypeString = _prefs?.getString(_selectedTypeKey);
    if (selectedTypeString != null) {
      _selectedType = ProductType.values
          .firstWhere((type) => type.toString() == selectedTypeString, orElse: () => ProductType.all);
    }
    notifyListeners();
  }

  void _loadProducts() {
    final productsString = _prefs?.getString(_productsKey);
    if (productsString != null) {
      final List<dynamic> productsJson = jsonDecode(productsString);
      _products = productsJson.map((product) => Product.fromMap(product)).toList();
      productsNotifier.value = _products;
    }
    notifyListeners();
  }

  void _loadSelectedProductId() {
    print("Preference Load: ${_prefs?.getInt(_selectedProductIdKey)}");
    _selectedProductId = _prefs?.getInt(_selectedProductIdKey) ?? 0;
    print("Preference Load Selected Product Id: $_selectedProductId");
  }

  void _saveSelectedProductId(int productId) {
    _prefs?.setInt(_selectedProductIdKey, productId);
    _selectedProductId = productId;
    notifyListeners();
  }

  void saveSelectedProductId(int productId) {
    print("Preference: ${_prefs?.getInt(_selectedProductIdKey)}");
    _saveSelectedProductId(productId);
  }

  void clearSelectedProductId() {
    _saveSelectedProductId(0);
  }

  Future<List<Product>> loadProducts(ProductType type) async {
    final productQuery = ProductQuery();
    final products = await productQuery.selectWithType(type);
    _clearProducts();
    _products = products;
    productsNotifier.value = _products;
    _selectedType = type;
    _saveSelectedType();
    _saveProducts();
    notifyListeners();
    return products;
  }

  void _clearProducts() {
    _products = [];
    productsNotifier.value = _products;
    _saveProducts();
    notifyListeners();
  }

  void _saveSelectedType() {
    _prefs?.setString(_selectedTypeKey, _selectedType.toString());
  }

  void _saveProducts() {
    final productsJson = jsonEncode(_products.map((product) => product.toJson()).toList());
    _prefs?.setString(_productsKey, productsJson);
  }

  Future<bool> addProduct(Product product) async {
    final productQuery = ProductQuery();
    final success = await productQuery.insert(product.toMap());
    if (success) {
      _products.add(product);
      productsNotifier.value = _products;
      _saveProducts();
      notifyListeners();
    }
    return success;
  }

  Future<bool> updateProduct(Product product) async {
    final productQuery = ProductQuery();
    final success = await productQuery.update(product.toMap(), 'id = ?', [product.id]);
    if (success) {
      final index = _products.indexWhere((p) => p.id == product.id);
      _products[index] = product;
      productsNotifier.value = _products;
      _saveProducts();
      notifyListeners();
    }
    return success;
  }

  Future<bool> deleteProduct(int id) async {
    final productQuery = ProductQuery();
    final success = await productQuery.delete(id);
    if (success > 0) {
      _products.removeWhere((product) => product.id == id);
      productsNotifier.value = _products;
      _saveProducts();
      notifyListeners();
    }
    return success > 0;
  }

  Future<Product> getProductById(int id) async {
    final productQuery = ProductQuery();
    final productMap = await productQuery.selectBy('id', id);
    return Product.fromMap(productMap);
    }
}
