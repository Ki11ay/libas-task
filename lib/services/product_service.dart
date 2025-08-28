import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

  // Get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      //print('🔍 Querying Firestore for products...');
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      //print('📊 Found ${snapshot.docs.length} product documents');
      
      final products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
      
      //print('✅ Successfully parsed ${products.length} products');
      return products;
    } catch (e) {
      //print('❌ Error fetching products: $e');
      return [];
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('category', isEqualTo: category)
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      //print('Error fetching products by category: $e');
      return [];
    }
  }

  // Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .get();

      final List<ProductModel> products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();

      // Filter products based on search query
      return products.where((product) {
        final searchQuery = query.toLowerCase();
        return product.name.toLowerCase().contains(searchQuery) ||
               product.description.toLowerCase().contains(searchQuery) ||
               product.category.toLowerCase().contains(searchQuery) ||
               product.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
      }).toList();
    } catch (e) {
      //print('Error searching products: $e');
      return [];
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final DocumentSnapshot doc = await _productsCollection.doc(productId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }
      return null;
    } catch (e) {
      //print('Error fetching product by ID: $e');
      return null;
    }
  }

  // Add product to Firestore
  Future<void> addProduct(ProductModel product) async {
    try {
      await _productsCollection.add(product.toJson());
      //print('Product added successfully: ${product.name}');
    } catch (e) {
      //print('Error adding product: $e');
      rethrow;
    }
  }

  // Update product
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _productsCollection.doc(productId).update(data);
      //print('Product updated successfully: $productId');
    } catch (e) {
      //print('Error updating product: $e');
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
      //print('Product deleted successfully: $productId');
    } catch (e) {
      //print('Error deleting product: $e');
      rethrow;
    }
  }

  // Get featured products (high rating or on sale)
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      //print('Error fetching featured products: $e');
      return [];
    }
  }

  // Get products on sale
  Future<List<ProductModel>> getProductsOnSale() async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .get();

      final List<ProductModel> products = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();

      // Filter products that are on sale
      return products.where((product) => product.isOnSale).toList();
    } catch (e) {
      //print('Error fetching products on sale: $e');
      return [];
    }
  }

  // Get products by price range
  Future<List<ProductModel>> getProductsByPriceRange(double minPrice, double maxPrice) async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .orderBy('price')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      //print('Error fetching products by price range: $e');
      return [];
    }
  }

  // Get categories
  Future<List<String>> getCategories() async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .get();

      final Set<String> categories = {};
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['category'] != null) {
          categories.add(data['category']);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      //print('Error fetching categories: $e');
      return [];
    }
  }

  // Get tags
  Future<List<String>> getTags() async {
    try {
      final QuerySnapshot snapshot = await _productsCollection
          .where('isAvailable', isEqualTo: true)
          .get();

      final Set<String> tags = {};
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['tags'] != null) {
          final List<dynamic> productTags = data['tags'];
          for (final tag in productTags) {
            if (tag is String) {
              tags.add(tag);
            }
          }
        }
      }

      return tags.toList()..sort();
    } catch (e) {
      //print('Error fetching tags: $e');
      return [];
    }
  }
}
