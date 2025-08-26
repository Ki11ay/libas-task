import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cart_item_model.dart';
import '../utils/constants.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppSizes.shadowSm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: CachedNetworkImage(
                imageUrl: item.productImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.divider,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.divider,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: AppSizes.md),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: AppSizes.xs),
                  
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.sm),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: item.quantity > 1
                                  ? () => onQuantityChanged(item.quantity - 1)
                                  : null,
                              icon: const Icon(Icons.remove, size: 18),
                              iconSize: 18,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onQuantityChanged(item.quantity + 1),
                              icon: const Icon(Icons.add, size: 18),
                              iconSize: 18,
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Remove Button
                      IconButton(
                        onPressed: onRemove,
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
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
