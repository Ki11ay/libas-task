import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/product_rating_dialog.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../l10n/app_localizations.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final List<CartItem>? purchasedItems;
  
  const PaymentSuccessScreen({
    super.key,
    this.purchasedItems,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    // Clear cart when payment is successful
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.clearCart();
      //print('Cart cleared after successful payment');
      //print('Purchased items: ${widget.purchasedItems?.length ?? 0}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppColors.success,
                ),
              ),
              
              const SizedBox(height: AppSizes.xl),
              
              // Success Title
              Text(
                AppLocalizations.of(context)!.paymentSuccessful,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Success Message
              Text(
                'Thank you for your purchase. Your order has been confirmed and will be processed soon.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSizes.xl),
              
              // Order Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.md),
                          Text(
                            'Order Details',
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      Row(
                        children: [
                          Text(
                            'Order Number:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'ORD-${DateTime.now().millisecondsSinceEpoch}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        children: [
                          Text(
                            'Date:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSizes.xl),
              
              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                      text: 'Continue Shopping',
                      icon: Icons.shopping_bag,
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  if (widget.purchasedItems != null && widget.purchasedItems!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          _showRatingDialog(context);
                        },
                        text: AppLocalizations.of(context)!.rateProducts,
                        backgroundColor: AppColors.accent,
                        icon: Icons.star,
                      ),
                    ),
                  if (widget.purchasedItems != null && widget.purchasedItems!.isNotEmpty)
                    const SizedBox(height: AppSizes.md),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/orders');
                      },
                      text: 'View Orders',
                      isOutlined: true,
                      icon: Icons.receipt,
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

  void _showRatingDialog(BuildContext context) {
    if (widget.purchasedItems != null && widget.purchasedItems!.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProductRatingDialog(
          purchasedItems: widget.purchasedItems!,
          onRatingSubmitted: (productId, rating, review) {
            // Here you would typically save the rating to your backend
            // For now, we'll just print it
            //print('Product $productId rated $rating stars with review: $review');
            
            // You can implement rating submission logic here
            // Example: save to Firestore, update product rating, etc.
          },
        ),
      );
    }
  }
}
