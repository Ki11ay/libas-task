import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../utils/constants.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.languageSelection,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                
                // English Option
                _buildLanguageOption(
                  context: context,
                  localeProvider: localeProvider,
                  languageCode: 'en',
                  languageName: l10n.english,
                  flag: '🇺🇸',
                  isSelected: localeProvider.isEnglish,
                ),
                
                const SizedBox(height: AppSizes.md),
                
                // Arabic Option
                _buildLanguageOption(
                  context: context,
                  localeProvider: localeProvider,
                  languageCode: 'ar',
                  languageName: l10n.arabic,
                  flag: '🇸🇦',
                  isSelected: localeProvider.isArabic,
                ),
                
                const Spacer(),
                
                // Info Text
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          'Language changes will take effect immediately. The app will restart to apply the new language.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required LocaleProvider localeProvider,
    required String languageCode,
    required String languageName,
    required String flag,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => localeProvider.setLanguage(languageCode),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                languageName,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
