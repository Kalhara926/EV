// lib/auth/login_or_register.dart

import 'package:flutter/material.dart';
import 'package:ev_charging_app/screens/login_screen.dart';
import 'package:ev_charging_app/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially, show the login page
  bool showLoginPage = true;

  // Toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(
          onTap: togglePages); // Login එක පෙන්නනවා, toggle function එකත් දෙනවා
    } else {
      return RegisterScreen(
          onTap:
              togglePages); // Register එක පෙන්නනවා, toggle function එකත් දෙනවා
    }
  }
}
