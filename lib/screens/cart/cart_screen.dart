import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/cart_item_card.dart';
import '../../l10n/app_localizations.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize cart when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.initializeCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.shoppingCart),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              if (cartProvider.hasItems) {
                return IconButton(
                  onPressed: () => _showClearCartDialog(context),
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: AppLocalizations.of(context)!.clearCart,
                );
              }
              return const SizedBox.shrink();
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

          if (cartProvider.error != null) {
            return Center(
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
                    AppLocalizations.of(context)!.errorLoadingCart,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    cartProvider.error!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  CustomButton(
                    onPressed: () => cartProvider.refreshCart(),
                    text: AppLocalizations.of(context)!.retry,
                    isOutlined: true,
                  ),
                ],
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
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    AppLocalizations.of(context)!.cartEmpty,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppLocalizations.of(context)!.cartEmptySubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),
                  CustomButton(
                    onPressed: () => Navigator.pop(context),
                    text: AppLocalizations.of(context)!.continueShopping,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Cart Items List
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
                        onQuantityChanged: (newQuantity) {
                          cartProvider.updateItemQuantity(item.id, newQuantity);
                        },
                        onRemove: () {
                          cartProvider.removeFromCart(item.id);
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
                      // Summary Details
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.subtotal,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${cartProvider.subtotal.toStringAsFixed(2)}',
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      if (cartProvider.totalSavings > 0) ...[
                        const SizedBox(height: AppSizes.sm),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.totalSavings,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '-\$${cartProvider.totalSavings.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: AppSizes.md),
                      
                      // Proceed to Payment Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () => _proceedToPayment(context),
                          text: AppLocalizations.of(context)!.proceedToPayment,
                        ),
                      ),
                      
                      const SizedBox(height: AppSizes.sm),
                      
                      // Continue Shopping Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () => Navigator.pop(context),
                          text: AppLocalizations.of(context)!.continueShopping,
                          isOutlined: true,
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.clearCart),
          content: Text(AppLocalizations.of(context)!.clearCartConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                cartProvider.clearCart();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: Text(AppLocalizations.of(context)!.clear),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    
    if (cartProvider.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cartEmpty),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Navigate to payment screen with cart items
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'items': cartProvider.cart!.items,
        'total': cartProvider.subtotal,
      },
    );
  }
}
