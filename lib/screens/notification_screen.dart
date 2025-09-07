// lib/screens/notification_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';

// Screen Imports for Bottom Nav
import 'package:ev_charging_app/screens/settings_screen.dart';
import 'package:ev_charging_app/screens/qr_scanner_screen.dart';
import 'package:ev_charging_app/screens/home_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: _buildCustomAppBar(context, l10n, textTheme),
      ),
      body: _buildEmptyState(textTheme),
      bottomNavigationBar: _buildBottomNavigationBar(context, l10n),
    );
  }

  Widget _buildCustomAppBar(
      BuildContext context, AppLocalizations l10n, TextTheme textTheme) {
    final userProfile =
        Provider.of<UserProfileProvider>(context, listen: false).userProfile;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Notification", // This can be localized
          style: textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Chip(
            avatar: Image.asset('assets/images/coins.png'),
            label: Text(
              '${userProfile?.evPoints.toStringAsFixed(2) ?? '0.00'} EV points',
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/no_notification.webp', // Ensure you have this asset
            height: 200,
            errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.notifications_off,
                size: 100,
                color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            "No Notification", // This can be localized
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, AppLocalizations l10n) {
    void _onItemTapped(int index) {
      if (index == 3) return; // Already on the notification screen, do nothing

      // Pop the current screen to go back to HomeScreen before navigating
      Navigator.of(context).popUntil((route) => route.isFirst);

      // We are now on the Home screen. From its context, push the new screen.
      // This is a common pattern for secondary screens.
      switch (index) {
        case 0: // Settings
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
          break;
        case 1: // Home - already handled by popUntil
          break;
        case 2: // Charge
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()));
          break;
      }
    }

    return BottomNavigationBar(
      currentIndex: 3, // This screen's index is 3
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
            icon: const Icon(Icons.settings), label: l10n.settings),
        BottomNavigationBarItem(
            icon: const Icon(Icons.home), label: l10n.drawerHome),
        BottomNavigationBarItem(
            icon: const Icon(Icons.bolt), label: l10n.chargeNow),
        const BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: "Notification"),
      ],
    );
  }
}
