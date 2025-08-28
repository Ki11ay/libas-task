import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication Methods
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // User Management
  Future<void> createUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Failed to create user profile: ${e.toString()}';
    }
  }

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user profile: ${e.toString()}';
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        ...data,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // Product Management
  Future<List<ProductModel>> getProducts() async {
    try {
      final querySnapshot = await _firestore.collection('products').get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw 'Failed to get products: $e';
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw 'Failed to get products by category: $e';
    }
  }

  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw 'Failed to get product: ${e.toString()}';
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '$query\uf8ff')
          .get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw 'Failed to search products: $e';
    }
  }

  // Cart Management - Note: Cart functionality moved to CartService
  // This method is kept for backward compatibility but will be removed
  Future<dynamic> getUserCart(String userId) async {
    throw 'Cart functionality has been moved to CartService. Please use CartProvider instead.';
  }

  Future<void> updateUserCart(String userId, dynamic cart) async {
    throw 'Cart functionality has been moved to CartService. Please use CartProvider instead.';
  }

  // Order Management
  Future<String> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore.collection('orders').add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw 'Failed to create order: $e';
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw 'Failed to get user orders: $e';
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  }

  // File Upload
  Future<String> uploadImage(String path, Uint8List imageBytes) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Failed to upload image: $e';
    }
  }

  // Error Handling
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-email':
          return 'The email address is invalid.';
        default:
          return error.message ?? 'Authentication failed.';
      }
    }
    return 'An unexpected error occurred.';
  }
}
