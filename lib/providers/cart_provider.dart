import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  CartModel? _cart;
  bool _isLoading = false;
  String? _error;

  CartModel? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _cart?.isEmpty ?? true;
  int get totalItems => _cart?.totalItems ?? 0;
  double get totalAmount => _cart?.totalAmount ?? 0.0;

  CartProvider();

  Future<void> loadUserCart(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      _cart = await _firebaseService.getUserCart(userId);
      if (_cart == null) {
        // Create new cart if none exists
        _cart = CartModel(
          id: userId,
          userId: userId,
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addToCart(String userId, ProductModel product, {int quantity = 1}) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_cart == null) {
        await loadUserCart(userId);
      }
      
      if (_cart != null) {
        final existingItemIndex = _cart!.items.indexWhere((item) => item.productId == product.id);
        
        if (existingItemIndex != -1) {
          // Update existing item quantity
          final existingItem = _cart!.items[existingItemIndex];
          final updatedItem = existingItem.copyWith(
            quantity: existingItem.quantity + quantity,
            addedAt: DateTime.now(),
          );
          _cart!.items[existingItemIndex] = updatedItem;
        } else {
          // Add new item
          final newItem = CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            productId: product.id,
            productName: product.name,
            productImage: product.images.isNotEmpty ? product.images.first : '',
            price: product.price,
            quantity: quantity,
            addedAt: DateTime.now(),
          );
          _cart!.items.add(newItem);
        }
        
        _cart = _cart!.copyWith(
          updatedAt: DateTime.now(),
        );
        
        await _saveCart(userId);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_cart != null) {
        _cart!.items.removeWhere((item) => item.productId == productId);
        _cart = _cart!.copyWith(
          updatedAt: DateTime.now(),
        );
        
        await _saveCart(userId);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateQuantity(String userId, String productId, int quantity) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_cart != null) {
        final itemIndex = _cart!.items.indexWhere((item) => item.productId == productId);
        if (itemIndex != -1) {
          if (quantity <= 0) {
            _cart!.items.removeAt(itemIndex);
          } else {
            final item = _cart!.items[itemIndex];
            _cart!.items[itemIndex] = item.copyWith(
              quantity: quantity,
              addedAt: DateTime.now(),
            );
          }
          
          _cart = _cart!.copyWith(
            updatedAt: DateTime.now(),
          );
          
          await _saveCart(userId);
        }
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (_cart != null) {
        _cart = _cart!.copyWith(
          items: [],
          updatedAt: DateTime.now(),
        );
        
        await _saveCart(userId);
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveCart(String userId) async {
    if (_cart != null) {
      await _firebaseService.updateUserCart(userId, _cart!);
      notifyListeners();
    }
  }

  CartItemModel? getCartItem(String productId) {
    if (_cart == null) return null;
    try {
      return _cart!.items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  bool isInCart(String productId) {
    return getCartItem(productId) != null;
  }

  int getItemQuantity(String productId) {
    final item = getCartItem(productId);
    return item?.quantity ?? 0;
  }

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
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  void refresh() {
    notifyListeners();
  }
}
