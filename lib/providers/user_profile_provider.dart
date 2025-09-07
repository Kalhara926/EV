// lib/providers/user_profile_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String uid;
  String firstName;
  String lastName;
  String email;
  String? profileImageUrl;
  int evPoints;
  final String role;
  UserProfile(
      {required this.uid,
      this.firstName = 'New',
      this.lastName = 'User',
      this.email = '',
      this.profileImageUrl,
      this.evPoints = 0,
      this.role = 'user'});
  String get fullName => '$firstName $lastName';
}

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  // --- Charging State Variables ---
  bool _isCurrentlyCharging = false;
  String? _activeChargerId;
  DateTime? _chargeEndTime;

  // --- Charging Session Details ---
  int _sessionDuration = 0;
  double _sessionRequiredPoints = 0;
  double _sessionEstimatedCost = 0;
  String _sessionStationName = '';
  String _sessionConnectorType = '';

  // --- Getters ---
  UserProfile? get userProfile => _userProfile;
  bool get isCurrentlyCharging => _isCurrentlyCharging;
  DateTime? get chargeEndTime => _chargeEndTime;
  int get sessionDuration => _sessionDuration;
  double get sessionRequiredPoints => _sessionRequiredPoints;
  double get sessionEstimatedCost => _sessionEstimatedCost;
  String get sessionStationName => _sessionStationName;
  String? get activeChargerId => _activeChargerId;
  String get sessionConnectorType => _sessionConnectorType;

  void listenToUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userSubscription?.cancel();
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          final pointsFromDb = data?['ev_points'] as num? ?? 0;
          _userProfile = UserProfile(
            uid: user.uid,
            firstName: data?['first_name'] ?? '',
            lastName: data?['last_name'] ?? '',
            email: data?['email'] ?? '',
            profileImageUrl: data?['profile_image_url'],
            evPoints: pointsFromDb.toInt(),
            role: data?['role'] ?? 'user',
          );
        }
        notifyListeners();
      });
    }
  }

  Future<void> updateUserPoints(int newPoints) async {
    if (_userProfile == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userProfile!.uid)
          .update({'ev_points': newPoints});
    } catch (e) {
      debugPrint("Error updating user points: $e");
    }
  }

  // --- Charging පටන් ගත්තම මේ function එක call කරනවා ---
  void startChargingSession({
    required String chargerId,
    required DateTime endTime,
    required int duration,
    required double points,
    required double cost,
    required String stationName,
    required String connectorType,
  }) {
    _isCurrentlyCharging = true;
    _activeChargerId = chargerId;
    _chargeEndTime = endTime;
    _sessionDuration = duration;
    _sessionRequiredPoints = points;
    _sessionEstimatedCost = cost;
    _sessionStationName = stationName;
    _sessionConnectorType = connectorType;
    notifyListeners();
  }

  // --- Charging නැවැත්තුවම මේ function එක call කරනවා ---
  void stopChargingSession() {
    _isCurrentlyCharging = false;
    _activeChargerId = null;
    _chargeEndTime = null;
    _sessionDuration = 0;
    _sessionRequiredPoints = 0;
    _sessionEstimatedCost = 0;
    _sessionStationName = '';
    _sessionConnectorType = '';
    notifyListeners();
  }

  void clearUserData() {
    _userSubscription?.cancel();
    _userProfile = null;
    stopChargingSession(); // Logout වෙද්දී charging state එකත් clear කරනවා
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }
}
