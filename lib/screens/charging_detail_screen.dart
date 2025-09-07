// lib/screens/charging_detail_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import 'package:ev_charging_app/widgets/payment_options_sheet.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'home_screen.dart';

class ChargingDetailScreen extends StatefulWidget {
  final int durationMinutes;
  final double requiredPoints;
  final double estimatedCost;
  final String chargerId;
  final String stationName;
  final String connectorType;

  const ChargingDetailScreen({
    Key? key,
    required this.durationMinutes,
    required this.requiredPoints,
    required this.estimatedCost,
    required this.chargerId,
    this.stationName = "Unknown Station",
    this.connectorType = "Type 2 AC",
  }) : super(key: key);

  @override
  _ChargingDetailScreenState createState() => _ChargingDetailScreenState();
}

class _ChargingDetailScreenState extends State<ChargingDetailScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseReference rtdbRef = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _rtdbSubscription;
  int _currentUserPoints = 0;
  bool _isChargingStarted = false;
  Timer? _chargingTimer;
  double _chargingPercentage = 0.0;
  int _timeElapsedSeconds = 0;
  int _currentVolts = 0;
  int _currentAmps = 0;
  bool _isPaymentProcessing = false;
  bool _hasPaymentBeenMade = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late DateTime _sessionStartTime;
  DateTime? _sessionEndTime;
  String _actualPaymentMethodUsed = "Points";

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Check if a session is already in progress from the provider
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    if (provider.isCurrentlyCharging &&
        provider.activeChargerId == widget.chargerId) {
      _isChargingStarted = true;
      _hasPaymentBeenMade = true;
      // We might need to reconstruct the timer state here if we want the timer to continue perfectly
      // For simplicity, we just restart the simulation, but the UI shows charging immediately.
      _startChargingSimulation();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = provider.userProfile;
      if (userProfile != null) {
        setState(() {
          _currentUserPoints = userProfile.evPoints;
        });
      }
    });

    _initializeChargingStateInRTDB();
  }

  Future<void> _initializeChargingStateInRTDB() async {
    // Only initialize if not already charging to avoid overwriting ongoing signals
    if (!_isChargingStarted) {
      try {
        await rtdbRef.update({
          'Time': widget.durationMinutes,
          'Start': 0,
          'Stop': 0,
          'Point': 0
        });
        await rtdbRef.child('Realtime/Time').set(null);
      } catch (e) {
        debugPrint("Error initializing RTDB state: $e");
      }
    }
  }

  @override
  void dispose() {
    _chargingTimer?.cancel();
    _animationController.dispose();
    _rtdbSubscription?.cancel();
    super.dispose();
  }

  Future<void> _stopChargingProcess({bool completed = false}) async {
    final l10n = AppLocalizations.of(context)!;

    // Stop provider session
    Provider.of<UserProfileProvider>(context, listen: false)
        .stopChargingSession();

    _chargingTimer?.cancel();
    _rtdbSubscription?.cancel();
    try {
      await rtdbRef.update(
          {'Start': 0, 'Stop': 1, 'Point': widget.requiredPoints.toInt()});
    } catch (e) {
      debugPrint("Error updating RTDB on stop: $e");
    }
    try {
      await FirebaseFirestore.instance
          .collection('chargers')
          .doc(widget.chargerId)
          .update({
        'isCharging': false,
        'status': 'available',
        'chargeUntil': null,
        'currentSessionUser': null
      });
      _sessionEndTime = DateTime.now();
      _recordChargingSession();
      if (mounted) {
        if (completed) {
          _showChargingCompletedPopup();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.chargingStopped),
              backgroundColor: Colors.red));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error stopping charge: $e')));
      }
    }
  }

  void _startChargingSimulation() {
    if (_isChargingStarted && _chargingTimer != null) {
      return; // Prevent restarting if already running
    }

    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    if (!userProfileProvider.isCurrentlyCharging) {
      userProfileProvider.startChargingSession(
        chargerId: widget.chargerId,
        endTime: DateTime.now().add(Duration(minutes: widget.durationMinutes)),
        duration: widget.durationMinutes,
        points: widget.requiredPoints,
        cost: widget.estimatedCost,
        stationName: widget.stationName,
        connectorType: widget.connectorType,
      );
    }

    try {
      rtdbRef.update({'Start': 1, 'Stop': 0});
    } catch (e) {
      debugPrint("Error updating RTDB on start: $e");
    }
    _rtdbSubscription = rtdbRef.child('Realtime').onValue.listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final voltageFromDb = (data['Voltage'] as num? ?? 0).toInt();
        final energyFromDb = (data['Energy'] as num? ?? 0).toInt();
        if (mounted) {
          setState(() {
            _currentVolts = voltageFromDb;
            _currentAmps = energyFromDb;
          });
        }
      }
    }, onError: (error) {
      debugPrint("Error listening to Realtime Database: $error");
    });

    _sessionStartTime = DateTime.now();
    setState(() {
      _isChargingStarted = true;
      _timeElapsedSeconds = 0;
      _chargingPercentage = 0.0;
    });

    final totalSeconds = widget.durationMinutes * 60;
    _chargingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _timeElapsedSeconds++;
        _chargingPercentage = _timeElapsedSeconds / totalSeconds;
        if (_chargingPercentage >= 1.0) {
          _chargingPercentage = 1.0;
          timer.cancel();
          _stopChargingProcess(completed: true);
        }
      });
    });
  }

  void _recordChargingSession() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final double averagePowerKw = (_currentVolts * _currentAmps) / 1000;
    final double actualDurationHours = _timeElapsedSeconds / 3600;
    final double actualEnergyConsumedKWh = averagePowerKw * actualDurationHours;
    final double actualCost = widget.estimatedCost;
    final sessionData = {
      'stationName': widget.stationName,
      'connectorType': widget.connectorType,
      'energyConsumedKWh': actualEnergyConsumedKWh,
      'cost': actualCost,
      'startTime': _sessionStartTime,
      'endTime': _sessionEndTime ?? DateTime.now(),
      'paymentMethod': _actualPaymentMethodUsed,
      'type': 'charging_session'
    };
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add(sessionData);
    } catch (e) {
      debugPrint("Error recording session: $e");
    }
  }

  void _showChargingCompletedPopup() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(l10n.chargingComplete,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          ]),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }),
          ],
        );
      },
    );
  }

  Future<void> _handlePayment() async {
    final l10n = AppLocalizations.of(context)!;
    if (_isPaymentProcessing || _hasPaymentBeenMade) return;
    setState(() => _isPaymentProcessing = true);
    await Future.delayed(const Duration(seconds: 1));
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    try {
      if (_currentUserPoints >= widget.requiredPoints) {
        int newPoints = _currentUserPoints - widget.requiredPoints.toInt();
        await userProfileProvider.updateUserPoints(newPoints);
        setState(() {
          _currentUserPoints = newPoints;
          _actualPaymentMethodUsed = "Points";
          _hasPaymentBeenMade = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(l10n.paymentConfirmed),
              backgroundColor: Colors.blue));
        }
      } else {
        double neededCash = (widget.requiredPoints - _currentUserPoints) * 1;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return PaymentOptionsSheet(
              amountToPay: neededCash,
              onPaymentSuccess: () async {
                await userProfileProvider.updateUserPoints(0);
                setState(() {
                  _currentUserPoints = 0;
                  _actualPaymentMethodUsed = "Cash/Card (Additional)";
                  _hasPaymentBeenMade = true;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(l10n.paymentConfirmed),
                      backgroundColor: Colors.blue));
                }
              },
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.paymentFailed(e.toString()))));
      }
    } finally {
      if (mounted) {
        setState(() => _isPaymentProcessing = false);
      }
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final int totalSeconds = widget.durationMinutes * 60;
    final int remainingSeconds =
        (totalSeconds - _timeElapsedSeconds).clamp(0, totalSeconds);
    final String remainingTimeString = _formatDuration(remainingSeconds);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.chargingSessionTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Text(l10n.yourSessionDetails,
                          style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface)),
                      const Divider(height: 30, thickness: 1.0),
                      _buildDetailRow(
                          l10n.duration,
                          l10n.minutes(widget.durationMinutes.toString()),
                          Icons.access_time),
                      _buildDetailRow(
                          l10n.evPointsRequired,
                          '${widget.requiredPoints.toStringAsFixed(1)} points',
                          Icons.flash_on),
                      _buildDetailRow(
                          l10n.estimatedCost,
                          'LKR ${widget.estimatedCost.toStringAsFixed(2)}',
                          Icons.money),
                      const SizedBox(height: 15),
                      Text(
                          l10n.yourAvailablePoints(
                              _currentUserPoints.toString()),
                          style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _currentUserPoints >= widget.requiredPoints
                                  ? colorScheme.secondary
                                  : colorScheme.error)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              if (!_isChargingStarted)
                if (!_hasPaymentBeenMade)
                  ElevatedButton(
                    onPressed: _isPaymentProcessing ? null : _handlePayment,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _currentUserPoints >= widget.requiredPoints
                                ? colorScheme.primary
                                : Colors.orange.shade700),
                    child: _isPaymentProcessing
                        ? const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3))
                        : Text(_currentUserPoints >= widget.requiredPoints
                            ? l10n.confirmAndPay
                            : l10n.payRemaining),
                  )
                else
                  ElevatedButton(
                    onPressed: _startChargingSimulation,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, size: 28),
                          const SizedBox(width: 10),
                          Text(l10n.startChargingNow)
                        ]),
                  )
              else
                Column(
                  children: [
                    Text(l10n.chargingInProgressTitle,
                        style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 25),
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 18.0,
                          percent: _chargingPercentage,
                          center: Text(
                              "${(_chargingPercentage * 100).toStringAsFixed(1)}%",
                              style: textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.secondary)),
                          progressColor: colorScheme.secondary,
                          backgroundColor:
                              colorScheme.secondary.withOpacity(0.2),
                          circularStrokeCap: CircularStrokeCap.round),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMetricCard(l10n.timeLeft, remainingTimeString,
                            Icons.hourglass_full, colorScheme.primary),
                        _buildMetricCard(l10n.volts, '${_currentVolts}V',
                            Icons.flash_on, Colors.orange),
                        _buildMetricCard(l10n.amps, '${_currentAmps}A',
                            Icons.power, Colors.purple),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => _stopChargingProcess(completed: false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.stop_circle, size: 28),
                            const SizedBox(width: 10),
                            Text(l10n.stopCharging)
                          ]),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, IconData icon) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 28),
          const SizedBox(width: 15),
          Expanded(
              child: Text(title,
                  style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7)))),
          Text(value,
              style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width / 3.8,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 35, color: color),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7))),
            const SizedBox(height: 4),
            Text(value,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
