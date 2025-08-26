import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.profile),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Text(
                    'Please sign in to view your profile',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  CustomButton(
                    onPressed: () {
                      // Navigate to auth
                    },
                    text: AppStrings.signIn,
                  ),
                ],
              ),
            );
          }

          final user = authProvider.userProfile;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: AppSizes.shadowSm,
                  ),
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primary,
                              )
                            : null,
                      ),
                      
                      const SizedBox(height: AppSizes.md),
                      
                      // User Name
                      Text(
                        user.displayName ?? 'User',
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: AppSizes.xs),
                      
                      // User Email
                      Text(
                        user.email,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      
                      const SizedBox(height: AppSizes.lg),
                      
                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: () {
                            // Navigate to edit profile
                          },
                          text: AppStrings.editProfile,
                          isOutlined: true,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                // Profile Menu
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: AppSizes.shadowSm,
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: AppStrings.orders,
                        subtitle: 'View your order history',
                        onTap: () {
                          // Navigate to orders
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.favorite_outline,
                        title: AppStrings.favorites,
                        subtitle: 'Your saved products',
                        onTap: () {
                          // Navigate to favorites
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        title: AppStrings.shippingAddress,
                        subtitle: 'Manage delivery addresses',
                        onTap: () {
                          // Navigate to shipping address
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.payment_outlined,
                        title: AppStrings.paymentMethods,
                        subtitle: 'Saved payment methods',
                        onTap: () {
                          // Navigate to payment methods
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        title: AppStrings.notifications,
                        subtitle: 'Manage notification preferences',
                        onTap: () {
                          // Navigate to notifications
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: AppStrings.privacy,
                        subtitle: 'Privacy and security settings',
                        onTap: () {
                          // Navigate to privacy
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: AppStrings.help,
                        subtitle: 'Get help and support',
                        onTap: () {
                          // Navigate to help
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.info_outline,
                        title: AppStrings.about,
                        subtitle: 'App information and version',
                        onTap: () {
                          // Navigate to about
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSizes.lg),
                
                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () => _showSignOutDialog(context),
                    text: AppStrings.signOut,
                    backgroundColor: AppColors.error,
                  ),
                ),
                
                const SizedBox(height: AppSizes.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(AppStrings.signOut),
          ),
        ],
      ),
    );
  }
}
