import 'package:flutter/material.dart';
import 'package:pos_portal/model/cart.dart';

class CartProvider extends ChangeNotifier {
  final List<Cart> _carts = [];

  List<Cart> get carts => _carts;

  void addToCart(Cart productCart) {
    final index = _carts.indexWhere((cart) => cart.productId == productCart.productId);
    if (index == -1) {
      _carts.add(productCart);
    } else {
      _carts[index].quantity += 1;
    }
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    final index = _carts.indexWhere((cart) => cart.productId == productId);
    if (_carts[index].quantity > 1) {
      _carts[index].quantity -= 1;
    } else {
      removeFromCart(productId);
    }

  }

  void clearCart() {
    _carts.clear();
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _carts.removeWhere((cart) => cart.productId == productId);
    notifyListeners();
  }

  bool isProductInCart(int productId) {
    return _carts.any((cart) => cart.productId == productId);
  }
}
