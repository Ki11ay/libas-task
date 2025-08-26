import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      
      if (authProvider.isAuthenticated) {
        cartProvider.loadUserCart(authProvider.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.cart),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.isEmpty) return const SizedBox.shrink();
              
              return TextButton(
                onPressed: () => _showClearCartDialog(context),
                child: Text(
                  'Clear',
                  style: TextStyle(color: AppColors.error),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    AppStrings.cartEmpty,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.cartEmptySubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  CustomButton(
                    onPressed: () {
                      // Navigate to products
                    },
                    text: 'Start Shopping',
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  itemCount: cartProvider.cart!.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cart!.items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: CartItemCard(
                        item: item,
                        onQuantityChanged: (quantity) {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          cartProvider.updateQuantity(
                            authProvider.user!.uid,
                            item.productId,
                            quantity,
                          );
                        },
                        onRemove: () {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          cartProvider.removeFromCart(
                            authProvider.user!.uid,
                            item.productId,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              
              // Cart Summary
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Summary Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppStrings.total} (${cartProvider.totalItems} items):',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppSizes.lg),
                      
                      // Checkout Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () => _proceedToCheckout(context),
                          text: AppStrings.checkout,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              cartProvider.clearCart(authProvider.user!.uid);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // Navigate to checkout screen
    // You can implement checkout navigation here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout functionality coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
