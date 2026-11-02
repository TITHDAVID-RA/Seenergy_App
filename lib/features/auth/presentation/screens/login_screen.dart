import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/language_controller.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/login_header.dart';

/// Clean, responsive mobile login screen with Khmer/English localization.
class LoginScreen extends StatefulWidget {
  final LanguageController languageController;

  const LoginScreen({
    super.key,
    required this.languageController,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language Switcher bar at top right
                Align(
                  alignment: Alignment.centerRight,
                  child: LanguageSwitcher(
                    controller: widget.languageController,
                  ),
                ),
                const SizedBox(height: 16),

                // Branding & Sign-in heading
                const LoginHeader(),
                const SizedBox(height: 28),

                // Email field
                CustomTextField(
                  label: l10n.emailLabel,
                  hintText: l10n.emailHint,
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Password field
                CustomTextField(
                  label: l10n.passwordLabel,
                  hintText: l10n.passwordHint,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.iconMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 28),

                // Log in button
                PrimaryButton(
                  text: l10n.logInButton,
                  onPressed: () {
                    // TODO: Handle authentication logic
                  },
                ),
                const SizedBox(height: 40),

                // Security badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l10n.protectedBy,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Copyright
                Text(
                  l10n.copyright,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

