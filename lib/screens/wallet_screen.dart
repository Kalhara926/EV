// lib/screens/wallet_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/transaction_tile.dart';
import 'all_transactions_screen.dart';
import 'profile_screen.dart';

// Screen Imports for Bottom Nav
import 'package:ev_charging_app/screens/settings_screen.dart';
import 'package:ev_charging_app/screens/qr_scanner_screen.dart';
import 'package:ev_charging_app/screens/notification_screen.dart';
import 'package:ev_charging_app/screens/home_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _topUpController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  late final DocumentReference _userDocRef;
  late final CollectionReference _transactionsCollectionRef;

  final int _bottomNavIndex =
      1; // Visually select the "Home" tab as Wallet is part of it

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
      _transactionsCollectionRef = _userDocRef.collection('transactions');
    }
  }

  @override
  void dispose() {
    _topUpController.dispose();
    super.dispose();
  }

  Future<void> _handleTopUp() async {
    final l10n = AppLocalizations.of(context)!;
    final amount = int.tryParse(_topUpController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.pleaseEnterValidAmount),
            backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(_userDocRef, {'ev_points': FieldValue.increment(amount)});
    batch.set(_transactionsCollectionRef.doc(), {
      'type': 'top_up',
      'amount': amount,
      'startTime': Timestamp.now(),
    });

    try {
      await batch.commit();
      if (mounted) {
        Navigator.pop(context);
        _topUpController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n.topUpSuccess(amount.toString())),
              backgroundColor: Theme.of(context).colorScheme.secondary),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(l10n.topUpFailed(e.toString())),
              backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      // Home tab
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      // First, go back to home to ensure a clean navigation stack
      Navigator.of(context).popUntil((route) => route.isFirst);
      // Then, push the new screen from home
      switch (index) {
        case 0:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
          break;
        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()));
          break;
        case 3:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationScreen()));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final userProfile = Provider.of<UserProfileProvider>(context).userProfile;

    if (currentUser == null || userProfile == null) {
      return Scaffold(
          appBar: AppBar(title: Text(l10n.myWalletTitle)),
          body: const Center(child: Text('Please log in')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.myWalletTitle,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen())),
              child: CircleAvatar(
                backgroundImage: userProfile.profileImageUrl != null &&
                        userProfile.profileImageUrl!.isNotEmpty
                    ? CachedNetworkImageProvider(userProfile.profileImageUrl!)
                    : null,
                child: userProfile.profileImageUrl == null ||
                        userProfile.profileImageUrl!.isEmpty
                    ? Icon(Icons.person, color: colorScheme.primary)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userDocRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final currentPoints = userData['ev_points'] ?? 0;

          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _buildPointsCard(l10n, textTheme, colorScheme, currentPoints),
              const SizedBox(height: 40),
              _buildTopUpSection(l10n, textTheme),
              const SizedBox(height: 40),
              _buildTransactionHistory(l10n, textTheme),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(l10n),
    );
  }

  Widget _buildPointsCard(AppLocalizations l10n, TextTheme textTheme,
      ColorScheme colorScheme, int currentPoints) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(l10n.availableEvPoints,
                style: textTheme.titleLarge
                    ?.copyWith(color: colorScheme.onPrimary.withOpacity(0.8))),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentPoints.toString(),
                    style: textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary)),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Icon(Icons.flash_on, color: Colors.amber, size: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUpSection(AppLocalizations l10n, TextTheme textTheme) {
    return Column(
      children: [
        Text(l10n.topUpYourWallet,
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        TextField(
          controller: _topUpController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.enterAmountPoints,
            prefixIcon: const Icon(Icons.add_circle_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleTopUp,
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(l10n.proceedToPay, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildTransactionHistory(AppLocalizations l10n, TextTheme textTheme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.transactionHistory, style: textTheme.titleLarge),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllTransactionsScreen())),
              child: Text(l10n.viewAll),
            ),
          ],
        ),
        const Divider(),
        StreamBuilder<QuerySnapshot>(
          stream: _transactionsCollectionRef
              .orderBy('startTime', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, transactionSnapshot) {
            if (transactionSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()));
            }
            if (transactionSnapshot.hasError) {
              return Center(child: Text('Error: ${transactionSnapshot.error}'));
            }
            if (!transactionSnapshot.hasData ||
                transactionSnapshot.data!.docs.isEmpty) {
              return Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(l10n.noRecentTransactions)));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = transactionSnapshot.data!.docs[index].data()
                    as Map<String, dynamic>;
                final type = data['type'] ?? 'unknown';
                final isTopUp = type == 'top_up';

                return TransactionTile(
                  type: type,
                  title: isTopUp
                      ? l10n.topUp
                      : (data['stationName'] ?? 'Charging Session'),
                  date: (data['startTime'] as Timestamp).toDate(),
                  amount: isTopUp ? (data['amount'] ?? 0) : (data['cost'] ?? 0),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(AppLocalizations l10n) {
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
