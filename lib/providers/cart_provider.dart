import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  // Getters
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasItems => _cart?.hasItems ?? false;
  bool get isEmpty => _cart?.isEmpty ?? true;
  int get totalItems => _cart?.totalItems ?? 0;
  double get subtotal => _cart?.subtotal ?? 0.0;
  double get totalSavings => _cart?.totalSavings ?? 0.0;
  int get uniqueProductsCount => _cart?.uniqueProductsCount ?? 0;

  // Initialize cart
  Future<void> initializeCart() async {
    try {
      _setLoading(true);
      _clearError();
      
      _cart = await _cartService.getUserCart();
      
      // Listen to cart changes
      _cartService.cartStream.listen((updatedCart) {
        _cart = updatedCart;
        notifyListeners();
      });
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add product to cart
  Future<void> addToCart(ProductModel product, {int quantity = 1, String? size, String? color}) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _cartService.addToCart(product, quantity: quantity, size: size, color: color);
      
      // Cart will be updated via stream
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _cartService.updateItemQuantity(itemId, newQuantity);
      
      // Cart will be updated via stream
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _cartService.removeFromCart(itemId);
      
      // Cart will be updated via stream
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      _setLoading(true);
      _clearError();
      
      await _cartService.clearCart();
      
      // Cart will be updated via stream
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Check if product is in cart
  Future<bool> isProductInCart(String productId, {String? size, String? color}) async {
    try {
      return await _cartService.isProductInCart(productId, size: size, color: color);
    } catch (e) {
      print('Error checking if product in cart: $e');
      return false;
    }
  }

  // Get cart item by product
  Future<CartItem?> getCartItemByProduct(String productId, {String? size, String? color}) async {
    try {
      return await _cartService.getCartItemByProduct(productId, size: size, color: color);
    } catch (e) {
      print('Error getting cart item by product: $e');
      return null;
    }
  }

  // Get cart total
  Future<double> getCartTotal() async {
    try {
      return await _cartService.getCartTotal();
    } catch (e) {
      print('Error getting cart total: $e');
      return 0.0;
    }
  }

  // Get cart items count
  Future<int> getCartItemsCount() async {
    try {
      return await _cartService.getCartItemsCount();
    } catch (e) {
      print('Error getting cart items count: $e');
      return 0;
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Clear error manually
  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Refresh cart
  Future<void> refreshCart() async {
    await initializeCart();
  }
}
