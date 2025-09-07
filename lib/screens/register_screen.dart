// lib/screens/register_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final companyNameController = TextEditingController(text: 'EV Hub');

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPersonalExpanded = true;
  bool _isSecurityExpanded = true;
  bool _isCompanyExpanded = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    companyNameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    final l10n = AppLocalizations.of(context)!;
    if (passwordController.text != confirmPasswordController.text) {
      showErrorMessage(l10n.passwordsDontMatch);
      return;
    }

    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'mobile_number': "+94${mobileController.text.trim()}",
        'company_name': companyNameController.text.trim(),
        'country': 'Sri Lanka',
        'uid': userCredential.user!.uid,
        'role': 'user',
        'ev_points': 0,
        'profile_image_url': null,
      });

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);
      showErrorMessage(e.message ?? 'An unknown error occurred');
    }
  }

  void showErrorMessage(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.registrationFailed),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 40),
                  const SizedBox(height: 8),
                  Text('ALL ELECTRIC, SUPER SMART',
                      style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.signUpTitle,
                      style: theme.textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Image.asset('assets/images/illustration.png', height: 60),
                ],
              ),
              const SizedBox(height: 20),

              // Sections
              _buildSectionHeader(
                  l10n.personal,
                  _isPersonalExpanded,
                  () => setState(
                      () => _isPersonalExpanded = !_isPersonalExpanded)),
              if (_isPersonalExpanded)
                _buildSectionContent([
                  _buildTextField(firstNameController, l10n.firstNameHint,
                      Icons.person_outline),
                  _buildTextField(lastNameController, l10n.lastNameHint,
                      Icons.person_outline),
                  _buildTextField(
                      emailController, l10n.emailHint, Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress),
                  _buildPhoneField(mobileController, l10n),
                ]),

              const SizedBox(height: 20),
              _buildSectionHeader(
                  l10n.security,
                  _isSecurityExpanded,
                  () => setState(
                      () => _isSecurityExpanded = !_isSecurityExpanded)),
              if (_isSecurityExpanded)
                _buildSectionContent([
                  _buildTextField(emailController, l10n.usernameHint,
                      Icons.account_circle_outlined,
                      isEnabled: false),
                  _buildPasswordField(
                      passwordController,
                      l10n.passwordHint,
                      _isPasswordVisible,
                      () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible)),
                  _buildPasswordField(
                      confirmPasswordController,
                      l10n.confirmPasswordHint,
                      _isConfirmPasswordVisible,
                      () => setState(() => _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible)),
                ]),

              const SizedBox(height: 20),
              _buildSectionHeader(
                  l10n.company,
                  _isCompanyExpanded,
                  () =>
                      setState(() => _isCompanyExpanded = !_isCompanyExpanded)),
              if (_isCompanyExpanded)
                _buildSectionContent([
                  _buildTextField(TextEditingController(text: l10n.sriLanka),
                      l10n.country, Icons.flag_outlined,
                      isEnabled: false),
                  _buildTextField(companyNameController, l10n.companyName,
                      Icons.business_outlined,
                      isEnabled: false),
                ]),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: signUpUser,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(l10n.signUpButton),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAccount,
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(l10n.loginNow,
                        style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, bool isExpanded, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold)),
            Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: child,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isEnabled = true, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          filled: !isEnabled,
          fillColor: Colors.grey.shade200),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText,
      bool isVisible, VoidCallback onVisibilityToggle) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.lock_outline,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        suffixIcon: IconButton(
          icon: Icon(isVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }

  Widget _buildPhoneField(
      TextEditingController controller, AppLocalizations l10n) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/sri_lanka_flag.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text('+94', style: TextStyle(fontSize: 16)),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
        hintText: l10n.mobileNumberHint,
      ),
    );
  }
}
