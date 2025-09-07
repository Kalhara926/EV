// lib/screens/charging_history_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import '../models/charging_session.dart';
import 'charging_receipt_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'qr_scanner_screen.dart';
import 'notification_screen.dart';

class ChargingHistoryScreen extends StatefulWidget {
  const ChargingHistoryScreen({super.key});

  @override
  State<ChargingHistoryScreen> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _animationTriggered = false;

  final int _bottomNavIndex = 1; // Visually select the "Home" tab

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      // If Home is tapped
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // For other tabs, first pop to home, then push the new screen.
    // This ensures a clean navigation stack.
    Navigator.of(context).popUntil((route) => route.isFirst);

    switch (index) {
      case 0: // Settings
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
        break;
      case 2: // Charge
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const QrScannerScreen()));
        break;
      case 3: // Notification
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final userProfile =
        Provider.of<UserProfileProvider>(context, listen: false).userProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.chargingHistoryTitle,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (userProfile != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                avatar: Image.asset('assets/images/coins.png'),
                label: Text(
                  '${userProfile.evPoints.toStringAsFixed(2)} EV points',
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.blue.shade50,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: userId == null
            ? const Center(child: Text("Please log in to see your history."))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('transactions')
                    .where('type', isEqualTo: 'charging_session')
                    .orderBy('startTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return _buildEmptyState(l10n, theme);
                  }

                  final historyDocs = snapshot.data!.docs;
                  if (!_animationTriggered) {
                    _animationController.forward();
                    _animationTriggered = true;
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    itemCount: historyDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          historyDocs[index].data() as Map<String, dynamic>;
                      final session = ChargingSession(
                        stationName: data['stationName'] ?? 'Unknown Station',
                        connectorType: data['connectorType'] ?? 'Type 2',
                        energyConsumedKWh:
                            (data['energyConsumedKWh'] as num? ?? 0).toDouble(),
                        cost: (data['cost'] as num? ?? 0).toDouble(),
                        startTime:
                            (data['startTime'] as Timestamp?)?.toDate() ??
                                DateTime.now(),
                        endTime: (data['endTime'] as Timestamp?)?.toDate() ??
                            DateTime.now(),
                        paymentMethod: data['paymentMethod'] ?? 'Points',
                      );
                      return _buildHistoryCard(session, theme, l10n);
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, l10n),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/no_history.webp', height: 200),
            const SizedBox(height: 30),
            Text(l10n.noChargingHistory,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(l10n.pastSessionsAppearHere,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey.shade500),
                textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: Text(l10n.startNewCharge),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
      ChargingSession session, ThemeData theme, AppLocalizations l10n) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChargingReceiptScreen(session: session)),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.ev_station_rounded,
                        color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.stationName,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy - hh:mm a')
                              .format(session.startTime.toLocal()),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                      l10n.energy,
                      '${session.energyConsumedKWh.toStringAsFixed(2)} kWh',
                      theme),
                  _buildDetailItem(l10n.cost,
                      'LKR ${session.cost.toStringAsFixed(2)}', theme),
                  _buildDetailItem(
                      l10n.duration,
                      _formatDuration(
                          session.endTime.difference(session.startTime)),
                      theme),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours);
    if (duration.inHours > 0) {
      return "${twoDigitHours}h ${twoDigitMinutes}m";
    } else {
      return "${twoDigitMinutes}m";
    }
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, AppLocalizations l10n) {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: _onBottomNavTapped,
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
            icon: Icon(Icons.notifications), label: "Notifications"),
      ],
    );
  }
}
