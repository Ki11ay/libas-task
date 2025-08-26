import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      _setLoading(true);
      _clearError();
      
      _products = await _firebaseService.getProducts();
      _extractCategories();
      _applyFilters();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (category == 'All') {
        _products = await _firebaseService.getProducts();
      } else {
        _products = await _firebaseService.getProductsByCategory(category);
      }
      _extractCategories();
      _applyFilters();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      _setLoading(true);
      _clearError();
      
      if (query.isEmpty) {
        _products = await _firebaseService.getProducts();
      } else {
        _products = await _firebaseService.searchProducts(query);
      }
      _searchQuery = query;
      _extractCategories();
      _applyFilters();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _extractCategories() {
    final categoriesSet = <String>{};
    for (final product in _products) {
      categoriesSet.add(product.category);
    }
    _categories = ['All', ...categoriesSet.toList()..sort()];
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<ProductModel> getFeaturedProducts() {
    return _products.where((product) => product.isFeatured).toList();
  }

  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
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
    loadProducts();
  }
}
