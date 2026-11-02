import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/language_controller.dart';
import '../localization/language_model.dart';

/// Interactive Language Switcher widget supporting Khmer and English.
class LanguageSwitcher extends StatelessWidget {
  final LanguageController controller;

  const LanguageSwitcher({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final currentCode = controller.languageCode;

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.supported.map((lang) {
              final isSelected = lang.code == currentCode;

              return GestureDetector(
                onTap: () => controller.changeLanguage(lang.locale),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lang.flag,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        lang.code.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
