import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  // Product card image with optimized caching
  static Widget buildProductImage({
    required String imageUrl,
    required String productId,
    double width = double.infinity,
    double height = double.infinity,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheKey: 'product_$productId',
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 800,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppColors.surface,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
                SizedBox(height: 8),
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'Image unavailable',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

      ),
    );
  }

  // Product detail image with high-quality caching
  static Widget buildProductDetailImage({
    required String imageUrl,
    required String productId,
    required int imageIndex,
    double width = double.infinity,
    double height = double.infinity,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheKey: 'product_detail_${productId}_$imageIndex',
        maxWidthDiskCache: 1200,
        maxHeightDiskCache: 1200,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppColors.divider,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                SizedBox(height: 8),
                Text(
                  'Loading image...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.divider,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Image unavailable',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  // Cart item image with compact caching
  static Widget buildCartItemImage({
    required String imageUrl,
    required String itemId,
    double width = 80,
    double height = 80,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        cacheKey: 'cart_item_$itemId',
        maxWidthDiskCache: 200,
        maxHeightDiskCache: 200,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppColors.divider,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.divider,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                'No image',
                style: TextStyle(
                  fontSize: 8,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
