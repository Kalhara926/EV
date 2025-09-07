// lib/screens/profile_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_app/auth/auth_gate.dart';
import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'customer_support_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const AuthGate();
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found.'));
          }

          final userData = snapshot.data!.data();
          final String name =
              '${userData?['first_name'] ?? ''} ${userData?['last_name'] ?? ''}';
          final String email = userData?['email'] ?? 'No email';
          final String mobile =
              userData?['mobile_number'] ?? 'No mobile number';
          final String? profileImageUrl = userData?['profile_image_url'];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280.0,
                pinned: true,
                stretch: true,
                backgroundColor: colorScheme.primary,
                iconTheme: IconThemeData(color: colorScheme.onPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16.0),
                  title: Text(
                    name,
                    style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        shadows: [
                          const Shadow(blurRadius: 2, color: Colors.black45)
                        ]),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/profile_background.png', // Add a suitable background image to assets
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: colorScheme.primary),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              colorScheme.primary.withOpacity(0.7),
                              Colors.black.withOpacity(0.3)
                            ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40), // Space for AppBar
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: colorScheme.surface,
                              child: CircleAvatar(
                                radius: 47,
                                backgroundImage: profileImageUrl != null &&
                                        profileImageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        profileImageUrl)
                                    : null,
                                child: profileImageUrl == null ||
                                        profileImageUrl.isEmpty
                                    ? Icon(Icons.person,
                                        size: 50, color: colorScheme.primary)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(email,
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimary
                                        .withOpacity(0.9))),
                            Text(mobile,
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onPrimary
                                        .withOpacity(0.9))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.headset_mic_outlined),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CustomerSupportScreen()))),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMenuListItem(
                            context,
                            l10n.editProfile,
                            Icons.edit_outlined,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(
                                        userData: userData ?? {})))),
                        _buildMenuListItem(
                            context,
                            l10n.settings,
                            Icons.settings_outlined,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen()))),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const AuthGate()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError),
                          child: Text(l10n.logout),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(child: Text('V. 1.0', style: textTheme.bodySmall)),
                  const SizedBox(height: 20),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuListItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
