// lib/screens/station_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package.flutter/material.dart';

import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_screen.dart';

// Screen Imports for Bottom Nav
import 'package:ev_charging_app/screens/settings_screen.dart';
import 'package:ev_charging_app/screens/qr_scanner_screen.dart';
import 'package:ev_charging_app/screens/notification_screen.dart';
import 'package:ev_charging_app/screens/home_screen.dart';

// Charger model class
class ChargerStation {
  final String id;
  final String locationName;
  final String owner;
  final LatLng coordinates;
  double? distanceInKm;

  ChargerStation({
    required this.id,
    required this.locationName,
    required this.owner,
    required this.coordinates,
    this.distanceInKm,
  });

  factory ChargerStation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint geoPoint = data['coordinates'] ?? const GeoPoint(0, 0);
    return ChargerStation(
      id: doc.id,
      locationName: data['location_name'] ?? 'Unknown Station',
      owner: data['owner'] ?? 'other',
      coordinates: LatLng(geoPoint.latitude, geoPoint.longitude),
    );
  }
}

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  final MapController _mapController = MapController();
  static const LatLng _sriLankaCenter = LatLng(7.8731, 80.7718);
  Position? _currentPosition;
  String? _locationError;
  int _bottomNavIndex = 1;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _locationError = null;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw 'Location services are disabled.';
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied)
          throw 'Location permissions are denied.';
      }
      if (permission == LocationPermission.deniedForever)
        throw 'Location permissions are permanently denied.';
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
        _mapController.move(
            LatLng(position.latitude, position.longitude), 13.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationError = e.toString();
        });
      }
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      // Home tab
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final userProfile =
        Provider.of<UserProfileProvider>(context, listen: false).userProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.findStationsTitle,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (userProfile != null)
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chargers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<ChargerStation> allStations = snapshot.data?.docs
                  .map((doc) => ChargerStation.fromFirestore(doc))
                  .toList() ??
              [];
          List<ChargerStation> nearbyStations = [];
          if (_currentPosition != null) {
            for (var station in allStations) {
              double distanceInMeters = Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  station.coordinates.latitude,
                  station.coordinates.longitude);
              if (distanceInMeters <= 5000) {
                station.distanceInKm = distanceInMeters / 1000;
                nearbyStations.add(station);
              }
            }
            nearbyStations
                .sort((a, b) => a.distanceInKm!.compareTo(b.distanceInKm!));
          }

          final allMarkers = allStations.map((station) {
            return Marker(
              point: station.coordinates,
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () => _showStationDetails(station, l10n, theme),
                child: Tooltip(
                  message: station.locationName,
                  child: Icon(
                    Icons.ev_station_rounded,
                    color: station.owner == 'own'
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    size: 45,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 5)
                    ],
                  ),
                ),
              ),
            );
          }).toList();

          if (_currentPosition != null) {
            allMarkers.add(Marker(
              point: LatLng(
                  _currentPosition!.latitude, _currentPosition!.longitude),
              child:
                  Icon(Icons.my_location, color: colorScheme.primary, size: 35),
            ));
          }

          return Column(
            children: [
              Expanded(
                flex: 3,
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude)
                        : _sriLankaCenter,
                    initialZoom: _currentPosition != null ? 12.0 : 7.5,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(markers: allMarkers),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: _buildNearbyStationsList(nearbyStations, l10n, theme),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(l10n),
    );
  }

  Widget _buildNearbyStationsList(List<ChargerStation> nearbyStations,
      AppLocalizations l10n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.stationsNearYou(5.toString()),
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (_currentPosition == null)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Finding your location..."))),
        if (_currentPosition != null && nearbyStations.isEmpty)
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(l10n.noStationsNearby(5.toString())))),
        if (nearbyStations.isNotEmpty)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: nearbyStations.length,
              itemBuilder: (context, index) {
                final station = nearbyStations[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Icon(Icons.ev_station_rounded,
                        color: station.owner == 'own'
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error),
                    title: Text(station.locationName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "${station.distanceInKm?.toStringAsFixed(1)} km away"),
                    onTap: () => _mapController.move(station.coordinates, 15.0),
                    trailing: IconButton(
                      icon: const Icon(Icons.directions),
                      onPressed: () {
                        final url =
                            'https://www.google.com/maps/dir/?api=1&destination=${station.coordinates.latitude},${station.coordinates.longitude}';
                        launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showStationDetails(
      ChargerStation station, AppLocalizations l10n, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.ev_station_rounded,
                      color: station.owner == 'own'
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.error,
                      size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(station.locationName,
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
              const Divider(height: 20),
              if (station.distanceInKm != null) ...[
                Text(
                    'Distance: ${station.distanceInKm?.toStringAsFixed(2)} km away',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 10),
              ],
              Text(
                  'Owner Type: ${station.owner == 'own' ? 'My Station' : 'Third-Party'}',
                  style: theme.textTheme.bodyLarge),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: Text(l10n.getDirections),
                  onPressed: () {
                    final url =
                        'https://www.google.com/maps/dir/?api=1&destination=${station.coordinates.latitude},${station.coordinates.longitude}';
                    launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
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
