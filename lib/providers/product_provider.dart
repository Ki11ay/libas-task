import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _categories = [];
  List<String> _tags = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedTag = '';
  double _minPrice = 0.0;
  double _maxPrice = double.infinity;
  String _sortBy = 'newest'; // newest, price_low, price_high, rating

  // Getters
  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<String> get categories => _categories;
  List<String> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedTag => _selectedTag;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get sortBy => _sortBy;

  ProductProvider() {
    _loadProducts();
    _loadCategories();
    _loadTags();
  }

  // Load all products
  Future<void> _loadProducts() async {
    try {
      _setLoading(true);
      _clearError();
      
      print('🔄 Loading products from Firestore...');
      _products = await _productService.getAllProducts();
      print('✅ Loaded ${_products.length} products from Firestore');
      
      _applyFilters();
      
    } catch (e) {
      print('❌ Error loading products: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load categories
  Future<void> _loadCategories() async {
    try {
      _categories = await _productService.getCategories();
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  // Load tags
  Future<void> _loadTags() async {
    try {
      _tags = await _productService.getTags();
      notifyListeners();
    } catch (e) {
      print('Error loading tags: $e');
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  // Search products
  Future<void> searchProducts(String query) async {
    try {
      _setLoading(true);
      _clearError();
      
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = await _productService.searchProducts(query);
      }
      
      _applyFilters();
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Filter by tag
  void filterByTag(String tag) {
    _selectedTag = tag;
    _applyFilters();
  }

  // Filter by price range
  void filterByPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  // Sort products
  void sortProducts(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    _selectedTag = '';
    _minPrice = 0.0;
    _maxPrice = double.infinity;
    _sortBy = 'newest';
    _applyFilters();
  }

  // Apply all filters and sorting
  void _applyFilters() {
    List<ProductModel> filtered = List.from(_products);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final query = _searchQuery.toLowerCase();
        return product.name.toLowerCase().contains(query) ||
               product.description.toLowerCase().contains(query) ||
               product.category.toLowerCase().contains(query) ||
               product.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory.isNotEmpty) {
      filtered = filtered.where((product) => 
        product.category == _selectedCategory
      ).toList();
    }

    // Apply tag filter
    if (_selectedTag.isNotEmpty) {
      filtered = filtered.where((product) => 
        product.tags.contains(_selectedTag)
      ).toList();
    }

    // Apply price filter
    filtered = filtered.where((product) => 
      product.price >= _minPrice && product.price <= _maxPrice
    ).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    _filteredProducts = filtered;
    notifyListeners();
  }

  // Get product by ID
  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get featured products
  List<ProductModel> getFeaturedProducts({int limit = 10}) {
    final featured = _products.where((product) => 
      product.rating >= 4.0 || product.isOnSale
    ).toList();
    
    featured.sort((a, b) => b.rating.compareTo(a.rating));
    return featured.take(limit).toList();
  }

  // Get products on sale
  List<ProductModel> getProductsOnSale() {
    return _products.where((product) => product.isOnSale).toList();
  }

  // Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // Add product (for admin use)
  Future<void> addProduct(ProductModel product) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _productService.addProduct(product);
      await _loadProducts(); // Reload products
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update product (for admin use)
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _productService.updateProduct(productId, data);
      await _loadProducts(); // Reload products
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Delete product (for admin use)
  Future<void> deleteProduct(String productId) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _productService.deleteProduct(productId);
      await _loadProducts(); // Reload products
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
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
}
