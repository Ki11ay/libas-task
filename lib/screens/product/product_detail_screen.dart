import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../l10n/app_localizations.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;
  ProductModel? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    _product = productProvider.getProductById(widget.productId);
    
    if (_product == null) {
      // Try to load from Firebase if not in local cache
      // This would typically be handled by the provider
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  void _addToCart() async {
    if (_product == null) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSignInToAddToCart),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    try {
      await cartProvider.addToCart(_product!, quantity: _quantity);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_product!.name} added to cart'),
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.viewCart,
            textColor: AppColors.surface,
            onPressed: () {
              // Navigate to cart
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _buyNow() {
    if (_product == null) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSignInToPurchase),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Navigate to checkout
    // You can implement checkout navigation here
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.productNotFound),
          backgroundColor: AppColors.surface,
        ),
        body: Center(
          child: Text(AppLocalizations.of(context)!.productNotFound),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.totalItems > 0) {
            return FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/cart'),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              icon: const Icon(Icons.shopping_cart),
              label: Text('${cartProvider.totalItems}'),
              heroTag: 'cart_fab',
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: const Icon(Icons.arrow_back),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Quick Add to Cart
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return FutureBuilder<bool>(
                    future: cartProvider.isProductInCart(_product!.id),
                    builder: (context, snapshot) {
                      final isInCart = snapshot.hasData && snapshot.data == true;
                      return IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                          ),
                          child: Icon(
                            isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                            color: isInCart ? AppColors.success : AppColors.textPrimary,
                          ),
                        ),
                        onPressed: () {
                          if (isInCart) {
                            // Navigate to cart
                            Navigator.pushNamed(context, '/cart');
                          } else {
                            // Quick add to cart
                            _addToCart();
                          }
                        },
                        tooltip: isInCart ? AppLocalizations.of(context)!.viewCart : AppLocalizations.of(context)!.addToCart,
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Icon(Icons.favorite_border),
                ),
                onPressed: () {
                  // Add to favorites
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Icon(Icons.share),
                ),
                onPressed: () {
                  // Share product
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Image Gallery
                  PageView.builder(
                    itemCount: _product!.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: _product!.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        // Enhanced caching for product detail images
                        cacheKey: 'product_detail_${_product!.id}_$index',
                        maxWidthDiskCache: 1200,
                        maxHeightDiskCache: 1200,
                        // Better placeholder
                        placeholder: (context, url) => Container(
                          color: AppColors.divider,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!.loadingImage,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Enhanced error handling
                        errorWidget: (context, url, error) => Container(
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
                                AppLocalizations.of(context)!.imageUnavailable,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                      );
                    },
                  ),
                  
                  // Image Indicators
                  if (_product!.images.length > 1)
                    Positioned(
                      bottom: AppSizes.lg,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _product!.images.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedImageIndex == index
                                  ? AppColors.primary
                                  : AppColors.surface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Cart Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _product!.name,
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Cart Status Badge
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          return FutureBuilder<bool>(
                            future: cartProvider.isProductInCart(_product!.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data == true) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.sm,
                                    vertical: AppSizes.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart,
                                        color: AppColors.surface,
                                        size: 16,
                                      ),
                                      const SizedBox(width: AppSizes.xs),
                                      Text(
                                        AppLocalizations.of(context)!.inCart,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.surface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.sm),
                  
                  // Category and Rating
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Text(
                          _product!.category,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_product!.rating > 0) ...[
                        Icon(
                          Icons.star,
                          size: 20,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          '${_product!.rating} (${_product!.reviewCount})',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Price
                  Row(
                    children: [
                      if (_product!.isOnSale) ...[
                        Text(
                          '\$${_product!.originalPrice!.toStringAsFixed(2)}',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                      ],
                      Text(
                        '\$${_product!.price.toStringAsFixed(2)}',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_product!.isOnSale) ...[
                        const SizedBox(width: AppSizes.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: Text(
                            '-${_product!.discountPercentage?.toStringAsFixed(0)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Stock Status
                  Row(
                    children: [
                      Icon(
                        _product!.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: _product!.isAvailable ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        _product!.isAvailable
                            ? AppLocalizations.of(context)!.inStock
                            : AppLocalizations.of(context)!.outOfStock,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _product!.isAvailable ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  
                  // Product Tags
                  if (_product!.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      AppLocalizations.of(context)!.tags,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Wrap(
                      spacing: AppSizes.xs,
                      runSpacing: AppSizes.xs,
                      children: _product!.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: AppSizes.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '#$tag',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Description
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    _product!.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // Quantity Selector
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.quantity,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: _quantity > 1
                                        ? () => setState(() => _quantity--)
                                        : null,
                                    icon: const Icon(Icons.remove),
                                    iconSize: 20,
                                    constraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_quantity',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _quantity < _product!.stockQuantity
                                        ? () => setState(() => _quantity++)
                                        : null,
                                    icon: const Icon(Icons.add),
                                    iconSize: 20,
                                    constraints: const BoxConstraints(
                                      minWidth: 40,
                                      minHeight: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        // Cart Status
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                            return FutureBuilder<bool>(
                              future: cartProvider.isProductInCart(_product!.id),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data == true) {
                                  return Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart,
                                        color: AppColors.success,
                                        size: 16,
                                      ),
                                      const SizedBox(width: AppSizes.xs),
                                      Text(
                                        AppLocalizations.of(context)!.alreadyInCart,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Price Summary
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${(_product!.price * _quantity).toStringAsFixed(2)}',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: _product!.isAvailable ? _addToCart : null,
                      text: AppLocalizations.of(context)!.addToCart,
                      isOutlined: true,
                      icon: Icons.shopping_cart_outlined,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: CustomButton(
                      onPressed: _product!.isAvailable ? _buyNow : null,
                        text: AppLocalizations.of(context)!.buyNow,
                      icon: Icons.flash_on,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
