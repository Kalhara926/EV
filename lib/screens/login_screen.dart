// lib/screens/login_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/language_provider.dart';

import 'package:ev_charging_app/auth/auth_service.dart';
import 'dart:io'; // To check platform

// --- අලුතෙන් Forgot Password Screen එක import කරනවා ---
import 'auth/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isSigningIn = false;

  final AuthService _authService = AuthService();

  void _socialSignIn(Future<UserCredential?> Function() signInMethod) async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      await signInMethod();
    } catch (e) {
      if (mounted) {
        showErrorMessage("Sign-in was cancelled or failed. Please try again.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  void signInUser() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);
      showErrorMessage(e.message ?? 'An unknown error occurred.');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Login Failed'),
                content: Text(message),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'))
                ]));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    const Map<String, String> languageMap = {
      'en': 'EN',
      'si': 'සිං',
      'ta': 'தமிழ்'
    };
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: _isSigningIn
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const Center(child: CircularProgressIndicator()))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('assets/images/logo.png', height: 40),
                      const SizedBox(height: 8),
                      Text('ALL ELECTRIC, SUPER SMART',
                          style: textTheme.bodySmall
                              ?.copyWith(color: colorScheme.secondary)),
                      const SizedBox(height: 30),
                      Image.asset('assets/images/login2.png', height: 150),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(l10n.loginTitle,
                              style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface)),
                          Container(
                            height: 40,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(20)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: languageProvider.locale.languageCode,
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black54),
                                items: languageMap.keys.map((String code) {
                                  return DropdownMenuItem<String>(
                                      value: code,
                                      child: Text(languageMap[code]!,
                                          style: textTheme.bodyLarge));
                                }).toList(),
                                onChanged: (String? newCode) {
                                  if (newCode != null) {
                                    languageProvider
                                        .changeLanguage(Locale(newCode));
                                  }
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return languageMap.keys
                                      .map<Widget>((String code) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.language,
                                            size: 20, color: Colors.black54),
                                        const SizedBox(width: 8),
                                        Text(languageMap[code]!)
                                      ],
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: l10n.usernameHint,
                              prefixIcon: const Icon(Icons.alternate_email))),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: l10n.passwordHint,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(() =>
                                  _isPasswordVisible = !_isPasswordVisible)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Checkbox(
                                value: _rememberMe,
                                onChanged: (value) =>
                                    setState(() => _rememberMe = value!)),
                            Text(l10n.rememberMe)
                          ]),

                          // --- මෙන්න වෙනස ---
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen()),
                                );
                              },
                              child: Text(l10n.forgotPassword)),
                          // ------------------
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: signInUser,
                              child: Text(l10n.loginTitle))),
                      const SizedBox(height: 30),
                      Row(children: [
                        const Expanded(child: Divider()),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child:
                                Text(l10n.orText, style: textTheme.bodySmall)),
                        const Expanded(child: Divider())
                      ]),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _socialSignIn(_authService.signInWithGoogle),
                          icon: Image.asset('assets/images/google_logo.png',
                              height: 24),
                          label: Text(l10n.loginWithGoogle),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (Platform.isIOS || Platform.isMacOS)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _socialSignIn(_authService.signInWithApple),
                            icon: const Icon(Icons.apple, color: Colors.white),
                            label: Text(l10n.signInWithApple),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                          ),
                        ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.newUserPrompt),
                          GestureDetector(
                              onTap: widget.onTap,
                              child: Text(l10n.signUpNow,
                                  style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold))),
                        ],
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
