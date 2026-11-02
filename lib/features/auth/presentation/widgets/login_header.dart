import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

/// Header widget displaying company branding and screen title.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Brand Logo Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.brandName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  l10n.brandSubtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Logo Symbol
            Container(
              width: 28,
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brandCyan, width: 2.5),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Welcome / Sign In Title
        Text(
          l10n.signInTitle,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.signInSubtitle,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

