import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../localization/language_controller.dart';
import 'hrms_home.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  // Test email pre-filled for easy testing as requested
  final _emailController = TextEditingController(text: 'admin@seenergy.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Automatically fills test credentials into the fields
  void _fillTestCredentials() {
    setState(() {
      _emailController.text = 'admin@seenergy.com';
      _passwordController.text = 'password123';
    });
  }

  /// Login authentication method
  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate email
    if (email.isEmpty) {
      _showError(l10n.emptyEmailError);
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showError(l10n.invalidEmailError);
      return;
    }

    // Validate password
    if (password.isEmpty) {
      _showError(l10n.emptyPasswordError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication processing
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Verify test credentials (or accept valid test account)
    final isValidTestAccount =
        (email.toLowerCase() == 'admin@seenergy.com' && password == 'password123') ||
        (email.isNotEmpty && password.length >= 6);

    if (isValidTestAccount) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to HRMS Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HrmsHomeScreen(userEmail: email),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      _showError(l10n.loginFailedError);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            // --- MAIN SCROLLABLE FORM ---
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),

                      // --- TOP BRAND LOGO ---
                      Center(
                        child: Image.asset(
                          'assets/seenergy_logo.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // --- HEADING ---
                      Text(
                        l10n.signIn,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.welcomeBack,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- TEST CREDENTIALS CHIP ---
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF2563EB)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.testAccountHint,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF1E3A8A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: _fillTestCredentials,
                              child: Text(
                                l10n.autoFillTest,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- EMAIL FIELD ---
                      Text(
                        l10n.emailLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: l10n.emailHint,
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF94A3B8), size: 20),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // --- PASSWORD FIELD ---
                      Text(
                        l10n.passwordLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: l10n.passwordHint,
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: const Color(0xFF94A3B8),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // --- LOG IN BUTTON ---
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.logIn,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                      ),

                      const SizedBox(height: 40),

                      // --- FOOTER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_rounded, size: 14, color: Color(0xFF2563EB)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              l10n.securityFooter,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.copyright,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- LANGUAGE SWITCHER BUTTON IN TOP-RIGHT CORNER ---
            Positioned(
              top: 12,
              right: 16,
              child: _buildTopRightLanguageButton(),
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive button to change language between English and Khmer
  Widget _buildTopRightLanguageButton() {
    final controller = LanguageController.instance;
    final isKhmer = controller.isKhmer;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // English button
          GestureDetector(
            onTap: () => controller.changeLanguage('en'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: !isKhmer ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇺🇸', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    'EN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: !isKhmer ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Khmer button
          GestureDetector(
            onTap: () => controller.changeLanguage('km'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isKhmer ? const Color(0xFF2563EB) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🇰🇭', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    'ខ្មែរ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isKhmer ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
