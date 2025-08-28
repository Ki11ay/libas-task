import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewProvider extends ChangeNotifier {
  final InAppReview _inAppReview = InAppReview.instance;
  
  bool _isLoading = false;
  String? _error;
  bool _isAvailable = false;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAvailable => _isAvailable;
  
  ReviewProvider() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Check if in-app review is available
      _isAvailable = await _inAppReview.isAvailable();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> requestReview() async {
    if (!_isAvailable) {
      _error = 'In-app review is not available on this device';
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      notifyListeners();
      
      await _inAppReview.requestReview();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> openStoreListing() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _inAppReview.openStoreListing();
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
