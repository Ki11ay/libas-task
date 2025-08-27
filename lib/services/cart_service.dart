import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get cart collection reference
  CollectionReference<Map<String, dynamic>> get _cartCollection =>
      _firestore.collection('carts');

  // Get current user's cart
  DocumentReference<Map<String, dynamic>> get _userCartRef =>
      _cartCollection.doc(_auth.currentUser?.uid);

  // Get user's cart
  Future<Cart?> getUserCart() async {
    try {
      if (_auth.currentUser == null) return null;

      final doc = await _userCartRef.get();
      if (doc.exists) {
        final data = doc.data()!;
        data['userId'] = doc.id;
        return Cart.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting user cart: $e');
      return null;
    }
  }

  // Create or update user's cart
  Future<void> saveCart(Cart cart) async {
    try {
      if (_auth.currentUser == null) return;

      await _userCartRef.set(cart.toJson());
    } catch (e) {
      print('Error saving cart: $e');
      rethrow;
    }
  }

  // Add product to cart
  Future<void> addToCart(ProductModel product, {int quantity = 1, String? size, String? color}) async {
    try {
      if (_auth.currentUser == null) return;

      Cart? currentCart = await getUserCart();
      
      // Create new cart if doesn't exist
      if (currentCart == null) {
        currentCart = Cart(
          userId: _auth.currentUser!.uid,
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      // Create cart item
      final cartItem = CartItem(
        id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        price: product.price,
        originalPrice: product.originalPrice,
        quantity: quantity,
        size: size,
        color: color,
      );

      // Add item to cart
      final updatedCart = currentCart.addItem(cartItem);
      await saveCart(updatedCart);
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  // Update item quantity
  Future<void> updateItemQuantity(String itemId, int newQuantity) async {
    try {
      if (_auth.currentUser == null) return;

      Cart? currentCart = await getUserCart();
      if (currentCart == null) return;

      final updatedCart = currentCart.updateItemQuantity(itemId, newQuantity);
      await saveCart(updatedCart);
    } catch (e) {
      print('Error updating item quantity: $e');
      rethrow;
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      if (_auth.currentUser == null) return;

      Cart? currentCart = await getUserCart();
      if (currentCart == null) return;

      final updatedCart = currentCart.removeItem(itemId);
      await saveCart(updatedCart);
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      if (_auth.currentUser == null) return;

      Cart? currentCart = await getUserCart();
      if (currentCart == null) return;

      final updatedCart = currentCart.clear();
      await saveCart(updatedCart);
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }

  // Check if product is in cart
  Future<bool> isProductInCart(String productId, {String? size, String? color}) async {
    try {
      if (_auth.currentUser == null) return false;

      Cart? currentCart = await getUserCart();
      if (currentCart == null) return false;

      return currentCart.containsProduct(productId, size: size, color: color);
    } catch (e) {
      print('Error checking if product in cart: $e');
      return false;
    }
  }

  // Get cart item by product
  Future<CartItem?> getCartItemByProduct(String productId, {String? size, String? color}) async {
    try {
      if (_auth.currentUser == null) return null;

      Cart? currentCart = await getUserCart();
      if (currentCart == null) return null;

      return currentCart.getItemByProduct(productId, size: size, color: color);
    } catch (e) {
      print('Error getting cart item by product: $e');
      return null;
    }
  }

  // Stream cart changes
  Stream<Cart?> get cartStream {
    if (_auth.currentUser == null) return Stream.value(null);

    return _userCartRef.snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        data['userId'] = doc.id;
        return Cart.fromJson(data);
      }
      return null;
    });
  }

  // Get cart total
  Future<double> getCartTotal() async {
    try {
      Cart? cart = await getUserCart();
      return cart?.subtotal ?? 0.0;
    } catch (e) {
      print('Error getting cart total: $e');
      return 0.0;
    }
  }

  // Get cart items count
  Future<int> getCartItemsCount() async {
    try {
      Cart? cart = await getUserCart();
      return cart?.totalItems ?? 0;
    } catch (e) {
      print('Error getting cart items count: $e');
      return 0;
    }
  }
}
