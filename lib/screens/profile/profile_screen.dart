import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/profile_menu_item.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart'; // Added import for LocationService
import '../../providers/locale_provider.dart'; // Added import for LocaleProvider
import '../../screens/profile/profile_edit_screen.dart'; // Added import for ProfileEditScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                    AppLocalizations.of(context)!.pleaseSignInToViewProfile,
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
                        user.displayName ?? AppLocalizations.of(context)!.user,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileEditScreen(),
                              ),
                            ).then((updated) {
                              if (updated == true) {
                                // Refresh the profile data
                                setState(() {});
                              }
                            });
                          },
                          text: AppLocalizations.of(context)!.editProfile,
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
                        subtitle: AppLocalizations.of(context)!.viewOrderHistory,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Orders feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.favorite_outline,
                        title: AppStrings.favorites,
                        subtitle: AppLocalizations.of(context)!.savedProducts,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Favorites feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        title: AppStrings.shippingAddress,
                        subtitle: AppLocalizations.of(context)!.manageDeliveryAddresses,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Shipping address feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.my_location,
                        title: AppLocalizations.of(context)!.updateLocation,
                        subtitle: AppLocalizations.of(context)!.refreshLocation,
                        onTap: () async {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          if (authProvider.user != null) {
                            // Show loading indicator
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.updatingLocation),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            
                            try {
                              final success = await LocationService.refreshUserLocation(authProvider.user!.uid);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.locationUpdateSuccess),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!.locationUpdateFailed),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)!.locationUpdateError(e.toString())),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.payment_outlined,
                        title: AppStrings.paymentMethods,
                        subtitle: AppLocalizations.of(context)!.savedPaymentMethods,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Payment methods feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        title: AppStrings.notifications,
                        subtitle: AppLocalizations.of(context)!.manageNotificationPreferences,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Notifications feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.language_outlined,
                        title: AppLocalizations.of(context)!.language,
                        subtitle: AppLocalizations.of(context)!.languageSelection,
                        onTap: () {
                          _showLanguageSelectionDialog(context);
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: AppStrings.privacy,
                        subtitle: AppLocalizations.of(context)!.privacyAndSecuritySettings,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Privacy settings feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: AppStrings.help,
                        subtitle: AppLocalizations.of(context)!.getHelpAndSupport,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Help & Support feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      ProfileMenuItem(
                        icon: Icons.info_outline,
                        title: AppStrings.about,
                        subtitle: AppLocalizations.of(context)!.appInformationAndVersion,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('About feature coming soon!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
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
        title: Text(AppLocalizations.of(context)!.signOut),
        content: Text(AppLocalizations.of(context)!.signOutConfirmation),
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

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Text(AppLocalizations.of(context)!.languageSelection),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changeLanguage(context, 'English');
            },
            child: Text(AppLocalizations.of(context)!.english),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _changeLanguage(context, 'Arabic');
            },
            child: Text(AppLocalizations.of(context)!.arabic),
          ),
        ],
      ),
    );
  }

  void _changeLanguage(BuildContext context, String language) {
    // Get the LocaleProvider and change the language
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = language == 'English' ? 'en' : 'ar';
    
    localeProvider.setLanguage(languageCode);
    
    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.languageChanged(language)),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
