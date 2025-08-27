import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

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
                'Payment Successful!',
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
}
