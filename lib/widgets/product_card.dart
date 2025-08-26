import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final bool showRating;
  final bool showDiscount;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showRating = true,
    this.showDiscount = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: AppSizes.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusLg),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusLg),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: product.images.isNotEmpty ? product.images.first : '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: AppColors.divider,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.divider,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textSecondary,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                    
                    // Discount Badge
                    if (showDiscount && product.hasDiscount)
                      Positioned(
                        top: AppSizes.sm,
                        left: AppSizes.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toInt()}%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    
                    // Out of Stock Badge
                    if (!product.isAvailable)
                      Positioned(
                        top: AppSizes.sm,
                        right: AppSizes.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary,
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: Text(
                            AppStrings.outOfStock,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppSizes.xs),
                  
                  // Category
                  Text(
                    product.category,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppSizes.sm),
                  
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.hasDiscount)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textTertiary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      // Rating
                      if (showRating && product.rating > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Text(
                              product.rating.toString(),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
