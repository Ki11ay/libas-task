import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                      boxShadow: AppSizes.shadowMd,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 40,
                      color: AppColors.surface,
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.lg),
                  
                  // App Name
                  Text(
                    AppStrings.appName,
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.sm),
                  
                  Text(
                    AppStrings.appTagline,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                boxShadow: AppSizes.shadowSm,
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  gradient: AppColors.primaryGradient,
                ),
                labelColor: AppColors.surface,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.button,
                unselectedLabelStyle: AppTextStyles.button.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: AppStrings.signIn),
                  Tab(text: AppStrings.signUp),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.lg),
            
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  SignInScreen(),
                  SignUpScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
