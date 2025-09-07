// lib/screens/my_vehicle_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'profile_screen.dart';

// Screen Imports for Bottom Nav
import 'package:ev_charging_app/screens/settings_screen.dart';
import 'package:ev_charging_app/screens/qr_scanner_screen.dart';
import 'package:ev_charging_app/screens/notification_screen.dart';

// --- Vehicle Model Class ---
class Vehicle {
  String id;
  String make;
  String model;
  String year;
  String licensePlate;
  String batteryCapacityKWh;
  String chargingPortType;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.batteryCapacityKWh,
    required this.chargingPortType,
  });

  factory Vehicle.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Vehicle(
      id: doc.id,
      make: data['make'] ?? '',
      model: data['model'] ?? '',
      year: data['year'] ?? '',
      licensePlate: data['licensePlate'] ?? '',
      batteryCapacityKWh: data['batteryCapacityKWh'] ?? '',
      chargingPortType: data['chargingPortType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'batteryCapacityKWh': batteryCapacityKWh,
      'chargingPortType': chargingPortType,
    };
  }
}

// --- Main Screen to Display Vehicles ---
class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});
  @override
  _MyVehicleScreenState createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late final CollectionReference _vehiclesRef;

  final int _currentTabIndexForNavigation = 1;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _vehiclesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('vehicles');
    }
  }

  void _addVehicle() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddEditVehicleScreen()));
  }

  void _editVehicle(Vehicle vehicle) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditVehicleScreen(vehicle: vehicle)));
  }

  void _deleteVehicle(String vehicleId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteVehicleTitle),
        content: Text(l10n.deleteVehicleConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () async {
              try {
                await _vehiclesRef.doc(vehicleId).delete();
                Navigator.pop(context);
                _showSnackBar(l10n.vehicleDeleted, isError: true);
              } catch (e) {
                Navigator.pop(context);
                _showSnackBar(l10n.errorDeletingVehicle(e.toString()),
                    isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green));
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      // Home tab
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // For other tabs, first go back to home, then push the new screen
    // This creates a consistent navigation flow
    Navigator.of(context).popUntil((route) => route.isFirst);

    switch (index) {
      case 0: // Settings
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
        break;
      case 2: // Charge (Scan QR)
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
    final userProfile =
        Provider.of<UserProfileProvider>(context, listen: false).userProfile;

    if (currentUser == null || userProfile == null) {
      return Scaffold(
          appBar: AppBar(title: Text(l10n.myVehiclesTitle)),
          body: const Center(child: Text('Please log in')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.myVehiclesTitle,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
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
                    ? Icon(Icons.person, color: theme.colorScheme.primary)
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vehiclesRef.snapshots(),
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

          final vehicles = snapshot.data!.docs
              .map((doc) => Vehicle.fromFirestore(
                  doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();
          return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
              itemCount: vehicles.length,
              itemBuilder: (context, index) =>
                  _buildVehicleCard(vehicles[index], l10n, theme));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVehicle,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(l10n),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_filled,
                size: 120, color: Colors.grey.shade300),
            const SizedBox(height: 30),
            Text(l10n.noVehiclesFound,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(l10n.addFirstVehiclePrompt,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _addVehicle,
              icon: const Icon(Icons.add_circle_outline, size: 28),
              label: Text(l10n.addYourFirstVehicle),
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
      Vehicle vehicle, AppLocalizations l10n, ThemeData theme) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _editVehicle(vehicle),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.make,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600)),
                      Text(vehicle.model,
                          style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary)),
                    ],
                  )),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editVehicle(vehicle);
                      } else if (value == 'delete') {
                        _deleteVehicle(vehicle.id);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem<String>(
                          value: 'delete', child: Text(l10n.delete)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildInfoRow(Icons.tag_rounded, l10n.licensePlate,
                  vehicle.licensePlate, theme),
              _buildInfoRow(Icons.battery_charging_full_rounded,
                  l10n.batteryCapacity, vehicle.batteryCapacityKWh, theme),
              _buildInfoRow(Icons.ev_station_rounded, l10n.chargingPort,
                  vehicle.chargingPortType, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Text('$label:', style: theme.textTheme.bodyLarge),
          const Spacer(),
          Text(value,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(AppLocalizations l10n) {
    return BottomNavigationBar(
      currentIndex: _currentTabIndexForNavigation,
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

// --- Add/Edit Vehicle Screen ---
class AddEditVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle;
  const AddEditVehicleScreen({Key? key, this.vehicle}) : super(key: key);
  @override
  _AddEditVehicleScreenState createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _makeController,
      _modelController,
      _yearController,
      _licensePlateController,
      _batteryCapacityController,
      _chargingPortTypeController;
  final List<String> _chargingPortTypes = [
    'Type 2 (Mennekes)',
    'CCS Combo 2',
    'CHAdeMO',
    'Other'
  ];
  String? _selectedChargingPortType;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController(text: widget.vehicle?.make ?? '');
    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _yearController = TextEditingController(text: widget.vehicle?.year ?? '');
    _licensePlateController =
        TextEditingController(text: widget.vehicle?.licensePlate ?? '');
    _batteryCapacityController =
        TextEditingController(text: widget.vehicle?.batteryCapacityKWh ?? '');
    _chargingPortTypeController = TextEditingController();
    if (widget.vehicle != null) {
      if (_chargingPortTypes.contains(widget.vehicle!.chargingPortType)) {
        _selectedChargingPortType = widget.vehicle!.chargingPortType;
      } else if (widget.vehicle!.chargingPortType.isNotEmpty) {
        _selectedChargingPortType = 'Other';
        _chargingPortTypeController.text = widget.vehicle!.chargingPortType;
      }
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _batteryCapacityController.dispose();
    _chargingPortTypeController.dispose();
    super.dispose();
  }

  void _saveVehicle() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _showSuccessSnackBar('You are not logged in.', isError: true);
        return;
      }
      final vehicleData = Vehicle(
        id: widget.vehicle?.id ?? '',
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        year: _yearController.text.trim(),
        licensePlate: _licensePlateController.text.trim(),
        batteryCapacityKWh: _batteryCapacityController.text.trim(),
        chargingPortType: _selectedChargingPortType == 'Other'
            ? _chargingPortTypeController.text.trim()
            : _selectedChargingPortType ?? '',
      );
      try {
        final vehiclesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('vehicles');
        if (widget.vehicle == null) {
          await vehiclesRef.add(vehicleData.toJson());
          _showSuccessSnackBar(l10n.addVehicle);
        } else {
          await vehiclesRef
              .doc(widget.vehicle!.id)
              .update(vehicleData.toJson());
          _showSuccessSnackBar(l10n.saveChanges);
        }
        Navigator.pop(context);
      } catch (e) {
        _showSuccessSnackBar('Failed to save vehicle: $e', isError: true);
      }
    }
  }

  void _showSuccessSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            widget.vehicle == null
                ? l10n.addNewVehicleTitle
                : l10n.editVehicleTitle,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextFormField(
                  controller: _makeController,
                  labelText: l10n.makeHint,
                  icon: Icons.directions_car_rounded),
              const SizedBox(height: 20),
              _buildTextFormField(
                  controller: _modelController,
                  labelText: l10n.modelHint,
                  icon: Icons.rv_hookup_rounded),
              const SizedBox(height: 20),
              _buildTextFormField(
                  controller: _yearController,
                  labelText: l10n.yearHint,
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildTextFormField(
                  controller: _licensePlateController,
                  labelText: l10n.licensePlate,
                  icon: Icons.badge_rounded),
              const SizedBox(height: 20),
              _buildTextFormField(
                  controller: _batteryCapacityController,
                  labelText: l10n.batteryCapacityHint,
                  icon: Icons.battery_charging_full_rounded),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedChargingPortType,
                decoration: InputDecoration(
                  labelText: l10n.chargingPortType,
                  prefixIcon: Icon(Icons.power_rounded,
                      color: theme.colorScheme.primary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                items: _chargingPortTypes
                    .map((String type) => DropdownMenuItem<String>(
                        value: type, child: Text(type)))
                    .toList(),
                onChanged: (String? newValue) =>
                    setState(() => _selectedChargingPortType = newValue),
                validator: (value) =>
                    value == null ? l10n.pleaseSelectType : null,
              ),
              if (_selectedChargingPortType == 'Other') ...[
                const SizedBox(height: 20),
                _buildTextFormField(
                    controller: _chargingPortTypeController,
                    labelText: l10n.specifyOtherPort,
                    icon: Icons.power_rounded)
              ],
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveVehicle,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(widget.vehicle == null
                    ? l10n.addVehicle
                    : l10n.saveChanges),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      {required TextEditingController controller,
      required String labelText,
      required IconData icon,
      TextInputType keyboardType = TextInputType.text}) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? l10n.fieldCannotBeEmpty : null,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
