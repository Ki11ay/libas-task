import 'package:flutter/material.dart';
import 'package:libas/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/review_provider.dart';
import '../../utils/constants.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer2<NotificationProvider, ReviewProvider>(
        builder: (context, notificationProvider, reviewProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(AppSizes.lg),
            children: [
              // Notification Permission Section
              _buildSection(
                title: AppLocalizations.of(context)!.notifications,
                children: [
                  _buildSwitchTile(
                    title: AppLocalizations.of(context)!.notifications,
                    subtitle: AppLocalizations.of(context)!.manageNotificationPreferences,
                    value: notificationProvider.permissionGranted,
                    onChanged: (value) {
                      if (value) {
                        notificationProvider.requestPermission();
                      }
                    },
                  ),
                  if (notificationProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (notificationProvider.error != null)
                    _buildErrorTile(notificationProvider.error!),
                ],
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Notification Topics Section
              _buildSection(
                title: AppLocalizations.of(context)!.notificationTopics,
                children: [
                  _buildTopicTile(
                    title: AppLocalizations.of(context)!.orderUpdates,
                    subtitle: AppLocalizations.of(context)!.orderUpdatesSubtitle,
                    topic: 'order_updates',
                    provider: notificationProvider,
                  ),
                  _buildTopicTile(
                    title: AppLocalizations.of(context)!.specialOffers,
                    subtitle: AppLocalizations.of(context)!.specialOffersSubtitle,
                    topic: 'special_offers',
                    provider: notificationProvider,
                  ),
                  _buildTopicTile(
                    title: AppLocalizations.of(context)!.newArrivals,
                    subtitle: AppLocalizations.of(context)!.newArrivalsSubtitle,
                    topic: 'new_arrivals',
                    provider: notificationProvider,
                  ),
                  _buildTopicTile(
                    title: AppLocalizations.of(context)!.categoryUpdates,
                    subtitle: AppLocalizations.of(context)!.categoryUpdatesSubtitle,
                    topic: 'category_updates',
                    provider: notificationProvider,
                  ),
                ],
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // In-App Review Section
              _buildSection(
                title: AppLocalizations.of(context)!.appReview,
                children: [
                  if (reviewProvider.isAvailable)
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.rateOurApp),
                      subtitle: Text(AppLocalizations.of(context)!.rateOurAppSubtitle),
                      leading: const Icon(Icons.star, color: AppColors.primary),
                      onTap: () => reviewProvider.requestReview(),
                      trailing: reviewProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.arrow_forward_ios, size: 16),
                    )
                  else
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.rateOurApp),
                      subtitle: Text(AppLocalizations.of(context)!.inAppReviewNotAvailable),
                      leading: const Icon(Icons.star, color: AppColors.textSecondary),
                      enabled: false,
                    ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.openStoreListing),
                    subtitle: Text(AppLocalizations.of(context)!.openStoreListingSubtitle),
                    leading: const Icon(Icons.store, color: AppColors.primary),
                    onTap: () => reviewProvider.openStoreListing(),
                    trailing: reviewProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  if (reviewProvider.error != null)
                    _buildErrorTile(reviewProvider.error!),
                ],
              ),
              
              const SizedBox(height: AppSizes.lg),
              
              // Notification History Section
              _buildSection(
                title: AppLocalizations.of(context)!.notificationHistory,
                children: [
                  if (notificationProvider.notifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(AppSizes.lg),
                      child: Center(
                        child: Text(
                          'No notifications yet',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    ...notificationProvider.notifications.map((notification) =>
                      _buildNotificationTile(notification, notificationProvider),
                    ),
                  if (notificationProvider.notifications.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => notificationProvider.markAllAsRead(),
                            child: Text(AppLocalizations.of(context)!.markAllAsRead),
                          ),
                          TextButton(
                            onPressed: () => notificationProvider.clearNotifications(),
                            child: Text(AppLocalizations.of(context)!.clearAll),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }

  Widget _buildTopicTile({
    required String title,
    required String subtitle,
    required String topic,
    required NotificationProvider provider,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: true, // You can implement topic subscription tracking
        onChanged: (value) {
          if (value) {
            provider.subscribeToTopic(topic);
          } else {
            provider.unsubscribeFromTopic(topic);
          }
        },
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNotificationTile(
    dynamic notification,
    NotificationProvider provider,
  ) {
    return ListTile(
      title: Text(
        notification.title ?? 'Notification',
        style: TextStyle(
          fontWeight: notification.isRead == true ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.body ?? ''),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(notification.timestamp),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(
          _getNotificationIcon(notification.type),
          color: AppColors.primary,
          size: 20,
        ),
      ),
      trailing: notification.isRead == true
          ? null
          : IconButton(
              icon: const Icon(Icons.mark_email_read, size: 20),
              onPressed: () => provider.markAsRead(notification.id),
            ),
      onTap: () {
        if (notification.isRead != true) {
          provider.markAsRead(notification.id);
        }
        // Handle notification tap based on payload
        _handleNotificationTap(notification);
      },
    );
  }

  Widget _buildErrorTile(String error) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: AppColors.error),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    
    try {
      final date = timestamp is String 
          ? DateTime.parse(timestamp)
          : timestamp as DateTime;
      
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  IconData _getNotificationIcon(dynamic type) {
    switch (type) {
      case 'welcome':
      case 'welcome_back':
        return Icons.waving_hand;
      case 'discount':
        return Icons.local_offer;
      case 'purchase_complete':
        return Icons.check_circle;
      case 'shipping_update':
        return Icons.local_shipping;
      case 'promotional':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  void _handleNotificationTap(dynamic notification) {
    // Handle navigation based on notification payload
    final payload = notification.payload;
    if (payload != null) {
      switch (payload) {
        case 'welcome':
        case 'welcome_back':
          // Navigate to home
          break;
        case 'discount':
          // Navigate to offers
          break;
        case 'purchase_complete':
          // Navigate to orders
          break;
        case 'shipping_update':
          // Navigate to order tracking
          break;
      }
    }
  }
}
