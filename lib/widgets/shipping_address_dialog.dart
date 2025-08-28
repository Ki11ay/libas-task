import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';

class ShippingAddressDialog extends StatelessWidget {
  final UserModel user;

  const ShippingAddressDialog({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = user.formattedAddress != null ||
        (user.streetName != null && user.city != null);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSizes.sm),
          Text(AppLocalizations.of(context)!.shippingAddressDetails),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: hasAddress ? _buildAddressContent(context) : _buildNoAddressContent(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.done),
        ),
        if (!hasAddress)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to address setup screen
              // You can implement this navigation
            },
            child: Text(AppLocalizations.of(context)!.setShippingAddress),
          ),
      ],
    );
  }

  Widget _buildAddressContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.formattedAddress != null) ...[
          _buildAddressRow(
            context,
            Icons.location_on,
            AppLocalizations.of(context)!.streetAddress,
            user.formattedAddress!,
          ),
        ] else ...[
          if (user.streetNumber != null && user.streetName != null)
            _buildAddressRow(
              context,
              Icons.home,
              AppLocalizations.of(context)!.streetAddress,
              '${user.streetNumber} ${user.streetName}',
            ),
          if (user.city != null)
            _buildAddressRow(
              context,
              Icons.location_city,
              AppLocalizations.of(context)!.city,
              user.city!,
            ),
          if (user.state != null)
            _buildAddressRow(
              context,
              Icons.map,
              AppLocalizations.of(context)!.state,
              user.state!,
            ),
          if (user.zipCode != null)
            _buildAddressRow(
              context,
              Icons.markunread_mailbox,
              AppLocalizations.of(context)!.zipCode,
              user.zipCode!,
            ),
          if (user.country != null)
            _buildAddressRow(
              context,
              Icons.public,
              AppLocalizations.of(context)!.country,
              user.country!,
            ),
        ],
        if (user.latitude != null && user.longitude != null) ...[
          const SizedBox(height: AppSizes.md),
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.gps_fixed,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSizes.xs),
                Text(
                  'GPS: ${user.latitude!.toStringAsFixed(6)}, ${user.longitude!.toStringAsFixed(6)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNoAddressContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.location_off_outlined,
          size: 48,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          AppLocalizations.of(context)!.noAddressSet,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAddressRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
