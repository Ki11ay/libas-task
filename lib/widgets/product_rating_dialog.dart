import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';
import '../services/rating_service.dart';
import '../providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductRatingDialog extends StatefulWidget {
  final List<CartItem> purchasedItems;
  final Function(String productId, double rating, String? review)? onRatingSubmitted;

  const ProductRatingDialog({
    super.key,
    required this.purchasedItems,
    this.onRatingSubmitted,
  });

  @override
  State<ProductRatingDialog> createState() => _ProductRatingDialogState();
}

class _ProductRatingDialogState extends State<ProductRatingDialog> {
  final Map<String, double> _ratings = {};
  final Map<String, TextEditingController> _reviewControllers = {};
  final Map<String, bool> _hasRated = {};

  @override
  void initState() {
    super.initState();
    // Initialize ratings and review controllers for each product
    for (final item in widget.purchasedItems) {
      _ratings[item.productId] = 0;
      _reviewControllers[item.productId] = TextEditingController();
      _hasRated[item.productId] = false;
    }
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (final controller in _reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radiusLg),
                  topRight: Radius.circular(AppSizes.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.surface,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.rateProductsAfterPurchase,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.rateProductsAfterPurchase,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    
                    // Product ratings
                    ...widget.purchasedItems.map((item) => _buildProductRatingItem(item)),
                    
                    const SizedBox(height: AppSizes.lg),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(AppLocalizations.of(context)!.skipRating),
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _canSubmit() ? _submitAllRatings : null,
                            child: Text(AppLocalizations.of(context)!.rateAllProducts),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductRatingItem(CartItem item) {
    final productId = item.productId;
    final rating = _ratings[productId] ?? 0;
    final hasRated = _hasRated[productId] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Image.network(
                    item.productImage,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: AppColors.divider,
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Qty: ${item.quantity}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSizes.md),
            
            // Rating stars
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.selectRating,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                ...List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _ratings[productId] = index + 1.0;
                        _hasRated[productId] = true;
                      });
                    },
                    child: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: index < rating ? AppColors.accent : AppColors.textSecondary,
                      size: 28,
                    ),
                  );
                }),
              ],
            ),
            
            if (rating > 0) ...[
              const SizedBox(height: AppSizes.sm),
              
              // Review text field
              TextField(
                controller: _reviewControllers[productId],
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.writeReview,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  contentPadding: const EdgeInsets.all(AppSizes.sm),
                ),
              ),
            ],
            
            if (hasRated) ...[
              const SizedBox(height: AppSizes.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      'Rated ${rating.toInt()}/5',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _ratings.values.any((rating) => rating > 0);
  }

  void _submitAllRatings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please sign in to submit ratings'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Submit all ratings
      for (final item in widget.purchasedItems) {
        final productId = item.productId;
        final rating = _ratings[productId] ?? 0;
        final review = _reviewControllers[productId]?.text.trim();
        
        if (rating > 0) {
          await RatingService().submitRating(
            productId: productId,
            userId: user.uid,
            rating: rating,
            review: review,
          );
          
          // Call the callback if provided
          widget.onRatingSubmitted?.call(productId, rating, review);
        }
      }
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.thankYouForRating),
          backgroundColor: AppColors.success,
        ),
      );
      
      // Refresh products to show updated ratings
      try {
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        await productProvider.refreshProducts();
        //print('✅ Products refreshed after rating submission');
      } catch (e) {
        //print('⚠️ Error refreshing products: $e');
      }
      
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting ratings: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
