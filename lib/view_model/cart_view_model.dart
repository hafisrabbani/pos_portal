import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cart.dart';

class CartViewModel with ChangeNotifier {
  static const String _cartKey = 'cart';
  SharedPreferences? _prefs;
  List<Cart> _cart = [];

  final ValueNotifier<List<Cart>> cartNotifier = ValueNotifier([]);
  int get cartLength => _cart.length;
  double total = 0;

  CartViewModel() {
    _init();
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCart();
  }

  void _loadCart() {
    final cartString = _prefs?.getString(_cartKey);
    if (cartString != null) {
      final List<dynamic> cartJson = jsonDecode(cartString);
      _cart = cartJson.map((cart) => Cart.fromMap(cart)).toList();
      cartNotifier.value = _cart;
    }
    notifyListeners();
  }

  List<Cart> loadCart() {
    return _cart;
  }

  void addCart(Cart cart) {
    final index = _cart.indexWhere((element) => element.productId == cart.productId);
    if (index != -1) {
      _cart[index].quantity = cart.quantity;
    } else {
      _cart.add(cart);
    }
    _saveCart();
  }

  void removeCart(int index) {
    _cart.removeAt(index);
    _saveCart();
  }

  void addOrRemoveCart(Cart cart) {
    final index = _cart.indexWhere((element) => element.productId == cart.productId);
    if (index != -1) {
      _cart.removeAt(index);
    } else {
      _cart.add(cart);
    }
    _saveCart();
  }

  void clearCart() {
    _cart.clear();
    _saveCart();
  }

  void _saveCart() {
    final cartString = jsonEncode(_cart);
    _prefs?.setString(_cartKey, cartString);
    cartNotifier.value = List<Cart>.from(_cart);
    notifyListeners();
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (final cart in _cart) {
      totalPrice += cart.price * cart.quantity;
    }
    return totalPrice;
  }
}
