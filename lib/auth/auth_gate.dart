// lib/auth/auth_gate.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider import කරන්න
import 'package:ev_charging_app/providers/user_profile_provider.dart'; // UserProfileProvider import කරන්න
import 'package:ev_charging_app/screens/home_screen.dart';
import 'package:ev_charging_app/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userProfileProvider =
              Provider.of<UserProfileProvider>(context, listen: false);

          // User log වෙලාද?
          if (snapshot.hasData) {
            // ---- User log වෙලා නම්, Provider එකට data listen කරන්න කියනවා ----
            userProfileProvider.listenToUserData();
            return const HomeScreen();
          }
          // User log වෙලා නැද්ද?
          else {
            // ---- User log වෙලා නැත්නම්, Provider එකේ data clear කරනවා ----
            userProfileProvider.clearUserData();
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
