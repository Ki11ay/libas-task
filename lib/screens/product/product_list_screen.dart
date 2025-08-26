import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.surface,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppStrings.appName,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surface,
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Featured Products Section
          SliverToBoxAdapter(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                final featuredProducts = productProvider.getFeaturedProducts();
                
                if (featuredProducts.isEmpty) return const SizedBox.shrink();
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Text(
                        'Featured Products',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                        scrollDirection: Axis.horizontal,
                        itemCount: featuredProducts.length,
                        itemBuilder: (context, index) {
                          final product = featuredProducts[index];
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: AppSizes.md),
                            child: ProductCard(
                              product: product,
                              onTap: () => _navigateToProductDetail(product.id),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                  ],
                );
              },
            ),
          ),
          
          // Categories Section
          SliverToBoxAdapter(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                      child: Text(
                        'Categories',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                        scrollDirection: Axis.horizontal,
                        itemCount: productProvider.categories.length,
                        itemBuilder: (context, index) {
                          final category = productProvider.categories[index];
                          final isSelected = productProvider.selectedCategory == category;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSizes.sm),
                            child: CategoryChip(
                              label: category,
                              isSelected: isSelected,
                              onTap: () => productProvider.selectCategory(category),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                  ],
                );
              },
            ),
          ),
          
          // Products Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            sliver: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }
                
                if (productProvider.error != null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            'Error loading products',
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            productProvider.error!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.lg),
                          ElevatedButton(
                            onPressed: () => productProvider.refresh(),
                            child: Text(AppStrings.retry),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                if (productProvider.filteredProducts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppSizes.md),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSizes.sm),
                          Text(
                            'Try adjusting your search or category filter',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppSizes.md,
                    mainAxisSpacing: AppSizes.md,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = productProvider.filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _navigateToProductDetail(product.id),
                      );
                    },
                    childCount: productProvider.filteredProducts.length,
                  ),
                );
              },
            ),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.xxl),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(productId: productId),
      ),
    );
  }
}
