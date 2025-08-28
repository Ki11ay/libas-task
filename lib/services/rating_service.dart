import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class RatingService {
  static final RatingService _instance = RatingService._internal();
  factory RatingService() => _instance;
  RatingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Submit a product rating
  Future<void> submitRating({
    required String productId,
    required String userId,
    required double rating,
    String? review,
  }) async {
    try {
      // Create rating document
      final ratingData = {
        'productId': productId,
        'userId': userId,
        'rating': rating,
        'review': review,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save rating to ratings collection
      await _firestore.collection('ratings').add(ratingData);

      // Update product's average rating
      await _updateProductRating(productId);

      print('Rating submitted successfully for product $productId');
    } catch (e) {
      print('Error submitting rating: $e');
      throw Exception('Failed to submit rating: $e');
    }
  }

  // Update product's average rating
  Future<void> _updateProductRating(String productId) async {
    try {
      // Get all ratings for this product
      final ratingsSnapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .get();

      if (ratingsSnapshot.docs.isEmpty) return;

      // Calculate average rating
      double totalRating = 0;
      int ratingCount = 0;

      for (final doc in ratingsSnapshot.docs) {
        final rating = doc.data()['rating'] as double?;
        if (rating != null) {
          totalRating += rating;
          ratingCount++;
        }
      }

      if (ratingCount > 0) {
        final averageRating = totalRating / ratingCount;

        // Update product document with new rating
        await _firestore.collection('products').doc(productId).update({
          'rating': averageRating, // Save to the 'rating' field that UI displays
          'reviewCount': ratingCount,
          'lastRatingUpdate': FieldValue.serverTimestamp(),
        });

        print('Product $productId rating updated: $averageRating ($ratingCount ratings)');
      }
    } catch (e) {
      print('Error updating product rating: $e');
    }
  }

  // Get product rating
  Future<Map<String, dynamic>?> getProductRating(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        final data = doc.data();
        return {
          'rating': data?['rating'] ?? 0.0,
          'reviewCount': data?['reviewCount'] ?? 0,
        };
      }
      return null;
    } catch (e) {
      print('Error getting product rating: $e');
      return null;
    }
  }

  // Get user's rating for a specific product
  Future<double?> getUserRating(String productId, String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['rating'] as double?;
      }
      return null;
    } catch (e) {
      print('Error getting user rating: $e');
      return null;
    }
  }

  // Get all ratings for a product
  Future<List<Map<String, dynamic>>> getProductRatings(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'userId': data['userId'],
          'rating': data['rating'],
          'review': data['review'],
          'timestamp': data['timestamp'],
        };
      }).toList();
    } catch (e) {
      print('Error getting product ratings: $e');
      return [];
    }
  }

  // Check if user has already rated a product
  Future<bool> hasUserRated(String productId, String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('ratings')
          .where('productId', isEqualTo: productId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user has rated: $e');
      return false;
    }
  }
}
