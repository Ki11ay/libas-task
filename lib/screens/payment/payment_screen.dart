import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/stripe_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> items;
  final double total;

  const PaymentScreen({
    super.key,
    required this.items,
    required this.total,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      // Create payment intent
      final paymentIntentData = await StripeService.createPaymentIntent(
        amount: widget.total,
        currency: 'usd',
      );

      // Get the client secret from the response
      final clientSecret = paymentIntentData['client_secret'] as String;
      if (clientSecret.isEmpty) {
        throw Exception('Invalid client secret received from Stripe');
      }

      // Initialize payment sheet
      await StripeService.initPaymentSheet(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Libas Store',
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize payment: $e';
      });
    }
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      print('Starting payment process...');
      
      // Present payment sheet
      print('Presenting payment sheet...');
      await StripeService.presentPaymentSheet();
      print('Payment sheet presented successfully');
      
      // Payment is automatically confirmed when using payment sheet
      // No need to manually call confirmPaymentSheetPayment()
      print('Payment automatically confirmed by Stripe payment sheet');

      // Payment successful - create order
      await _createOrder();

      // Clear cart
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.clearCart();
      
      print('Payment completed successfully!');
      print('Cart cleared, navigating to success screen with ${widget.items.length} items');

      // Navigate to success screen with purchased items
      if (mounted) {
        Navigator.pushReplacementNamed(
          context, 
          '/payment-success',
          arguments: widget.items,
        );
      }
      
    } catch (e) {
      print('Payment failed with error: $e');
      setState(() {
        _errorMessage = 'Payment failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _createOrder() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.uid;
    
    if (userId == null) throw Exception('User not authenticated');

    // Create order (for now, just log it - implement order provider later)
    print('Order created: ${DateTime.now().millisecondsSinceEpoch}');
    
    // TODO: Implement order creation with provider
    // final order = OrderModel(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   userId: userId,
    //   orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
    //   items: widget.items,
    //   subtotal: widget.total,
    //   tax: StripeService.calculateTax(widget.total, 8.5),
    //   shipping: 0.0,
    //   total: widget.total,
    //   status: 'pending',
    //   paymentStatus: 'paid',
    //   shippingAddress: 'User address',
    //   billingAddress: 'User address',
    //   createdAt: DateTime.now(),
    // );
    // await orderProvider.createOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.payment),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.orderSummary,
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: AppSizes.md),
                    ...widget.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.productName),
                          ),
                          Text('x${item.quantity}'),
                          const SizedBox(width: AppSizes.md),
                          Text(StripeService.formatAmount(item.price * item.quantity)),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.total,
                          style: AppTextStyles.h4,
                        ),
                        const Spacer(),
                        Text(
                          StripeService.formatAmount(widget.total),
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            // Payment Information
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.payment,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSizes.md),
                        Text(
                          AppLocalizations.of(context)!.paymentDetails,
                          style: AppTextStyles.h4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      'We\'ll use Stripe to securely process your payment. Your card information is encrypted and never stored on our servers.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        border: Border.all(color: AppColors.info),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 16,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: Text(
                              '💳 Test Mode: Using Stripe test environment. Use test card numbers for testing.',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSizes.md),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.error),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: AppSizes.xl),
            
            // Payment Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: _isProcessing ? null : _processPayment,
                text: _isProcessing 
                  ? AppLocalizations.of(context)!.processing 
                  : AppLocalizations.of(context)!.payNow,
                icon: _isProcessing ? null : Icons.payment,
              ),
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Security Notice
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.success),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      'Your payment is secured by Stripe\'s industry-leading security standards',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
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
