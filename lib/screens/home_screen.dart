// lib/screens/home_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:async';

// Screen Imports
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import 'package:ev_charging_app/screens/profile_screen.dart';
import 'package:ev_charging_app/screens/history_screen.dart';
import 'package:ev_charging_app/screens/wallet_screen.dart';
import 'package:ev_charging_app/screens/qr_scanner_screen.dart';
import 'package:ev_charging_app/screens/station_screen.dart';
import 'package:ev_charging_app/screens/my_vehicle_screen.dart';
import 'package:ev_charging_app/screens/notification_screen.dart';
import 'package:ev_charging_app/screens/about_us_screen.dart';
import 'package:ev_charging_app/screens/terms_conditions_screen.dart';
import 'package:ev_charging_app/screens/privacy_policy_screen.dart';
import 'package:ev_charging_app/screens/emergency_call_screen.dart';
import 'package:ev_charging_app/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _bottomNavIndex = 1;

  void _onBottomNavTapped(int index) {
    if (index == _bottomNavIndex) return;

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
      default:
        // This case is for Home (index 1), we are already here.
        setState(() {
          _bottomNavIndex = index;
        });
    }
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) {
        if (userProfileProvider.userProfile == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final userProfile = userProfileProvider.userProfile!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Builder(
                builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: colorScheme.onSurface),
                    onPressed: () => Scaffold.of(context).openDrawer())),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome,",
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
                Text(userProfile.firstName,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
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
                        ? CachedNetworkImageProvider(
                            userProfile.profileImageUrl!)
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
          drawer: _buildAppDrawer(context, userProfile, l10n),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPointsCard(textTheme, userProfile),
              const SizedBox(height: 20),
              _buildImageSlider(),
              const SizedBox(height: 20),
              // --- මෙන්න වෙනස #2 ---
              Text("Our Products",
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildProductCards(),
              const SizedBox(height: 20),
              _buildQuickActionGrid(context, l10n),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(l10n),
        );
      },
    );
  }

  Widget _buildPointsCard(TextTheme textTheme, UserProfile userProfile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/coins.png',
                  width: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.monetization_on, color: Colors.amber)),
              const SizedBox(width: 8),
              Text("You can spend up to", style: textTheme.bodySmall),
            ],
          ),
          Text(
            "${userProfile.evPoints.toStringAsFixed(2)} EV points",
            style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, color: Colors.blue.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSlider() {
    final List<String> banners = [
      'assets/images/banner1.jpeg',
      'assets/images/banner2.jpeg',
      'assets/images/banner3.jpeg'
    ];

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Image.asset(
              banners[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey))),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCards() {
    final List<String> productImages = [
      'assets/images/product1.jpeg',
      'assets/images/product2.jpeg',
      'assets/images/product3.jpeg',
      'assets/images/product4.jpeg',
    ];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productImages.length,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.only(right: 10),
            child: Image.asset(
              productImages[index],
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  color: Colors.grey.shade200,
                  child: const Center(
                      child: Icon(Icons.business_center,
                          size: 40, color: Colors.grey))),
            ),
          );
        },
      ),
    );
  }

  // --- මෙන්න වෙනස #1 ---
  Widget _buildQuickActionGrid(BuildContext context, AppLocalizations l10n) {
    return GridView.count(
      crossAxisCount: 2, // Columns ගාන 2ක් කළා
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5, // Items ටික පළල වෙන්න ratio එක වෙනස් කළා
      children: [
        _buildGridItem(context, l10n.wallet,
            Icons.account_balance_wallet_outlined, const WalletScreen()),
        _buildGridItem(context, l10n.myVehicle, Icons.directions_car_outlined,
            const MyVehicleScreen()),
        _buildGridItem(
            context, 'Scan QR', Icons.qr_code_scanner, const QrScannerScreen()),
        _buildGridItem(context, l10n.stations, Icons.explore_outlined,
            const StationScreen()),
      ],
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => screen)),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
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

  Widget _buildAppDrawer(
      BuildContext context, UserProfile userProfile, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(userProfile.fullName,
                  style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold)),
              accountEmail: Text(userProfile.email,
                  style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withOpacity(0.8))),
              currentAccountPicture: CircleAvatar(
                  backgroundColor: colorScheme.surface,
                  backgroundImage: userProfile.profileImageUrl != null &&
                          userProfile.profileImageUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(userProfile.profileImageUrl!)
                      : null,
                  child: userProfile.profileImageUrl == null ||
                          userProfile.profileImageUrl!.isEmpty
                      ? Icon(Icons.person, size: 40, color: colorScheme.primary)
                      : null),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight))),
          _buildDrawerListTile(context, Icons.home_outlined, l10n.drawerHome,
              () => Navigator.pop(context)),
          _buildDrawerListTile(context, Icons.map_outlined, l10n.stations, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StationScreen()));
          }),
          _buildDrawerListTile(
              context, Icons.directions_car_outlined, l10n.myVehicle, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyVehicleScreen()));
          }),
          _buildDrawerListTile(
              context, Icons.account_balance_wallet_outlined, l10n.wallet, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const WalletScreen()));
          }),
          const Divider(indent: 16, endIndent: 16),
          _buildDrawerListTile(context, Icons.history_outlined, l10n.history,
              () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChargingHistoryScreen()));
          }),
          _buildDrawerListTile(context, Icons.info_outline, l10n.drawerAboutUs,
              () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()));
          }),
          _buildDrawerListTile(
              context, Icons.policy_outlined, l10n.drawerPrivacyPolicy, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen()));
          }),
          _buildDrawerListTile(
              context, Icons.description_outlined, l10n.drawerTerms, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TermsConditionsScreen()));
          }),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
              leading: Icon(Icons.sos_rounded, color: colorScheme.error),
              title: Text('Emergency Support',
                  style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergencyCallScreen()));
              }),
          const Divider(indent: 16, endIndent: 16),
          ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error),
              title: Text(l10n.signOut,
                  style:
                      textTheme.bodyLarge?.copyWith(color: colorScheme.error)),
              onTap: _signOut),
        ],
      ),
    );
  }

  Widget _buildDrawerListTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
        leading: Icon(icon,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        onTap: onTap);
  }
}
