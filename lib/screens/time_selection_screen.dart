// lib/screens/time_selection_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ev_charging_app/screens/charging_detail_screen.dart';

class TimeSelectionScreen extends StatefulWidget {
  final String chargerId;
  final String stationName;

  const TimeSelectionScreen({
    Key? key,
    required this.chargerId,
    required this.stationName,
  }) : super(key: key);

  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedMinutes = 30;
  final double _pointsPerMinute = 0.5;
  final double _costPerPoint = 100.0;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _proceedToChargingDetails() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedMinutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.pleaseSelectValidDuration),
            backgroundColor: Theme.of(context).colorScheme.error),
      );
      return;
    }

    final double requiredPoints = _selectedMinutes * _pointsPerMinute;
    final double estimatedCost = requiredPoints * _costPerPoint;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChargingDetailScreen(
          durationMinutes: _selectedMinutes,
          requiredPoints: requiredPoints,
          estimatedCost: estimatedCost,
          chargerId: widget.chargerId,
          stationName: widget.stationName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    double requiredPoints = _selectedMinutes * _pointsPerMinute;
    double estimatedCost = requiredPoints * _costPerPoint;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.selectChargingTimeTitle),
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    color: colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 28.0, horizontal: 20.0),
                      child: Column(
                        children: [
                          Text(widget.stationName,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text(widget.chargerId,
                              style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onPrimary,
                                  letterSpacing: 1.2)),
                          const SizedBox(height: 6),
                          Text(l10n.readyForCharging,
                              style: textTheme.bodyMedium?.copyWith(
                                  color:
                                      colorScheme.onPrimary.withOpacity(0.8))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(l10n.howLongToCharge,
                      style: textTheme.headlineSmall
                          ?.copyWith(color: colorScheme.onBackground),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Text(l10n.minutes(_selectedMinutes.toString()),
                          style: textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary)),
                      Slider(
                        min: 5,
                        max: 240,
                        divisions: (240 - 5) ~/ 5,
                        value: _selectedMinutes.toDouble(),
                        label: '$_selectedMinutes min',
                        onChanged: (value) {
                          setState(() {
                            _selectedMinutes = value.round();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('5 min', style: textTheme.bodySmall),
                            Text('240 min', style: textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.chargingSummary,
                              style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface)),
                          const Divider(height: 24, thickness: 1.0),
                          _buildSummaryRow(
                              l10n.duration,
                              l10n.minutes(_selectedMinutes.toString()),
                              Icons.timer,
                              colorScheme.primary),
                          _buildSummaryRow(
                              l10n.evPointsRequired,
                              '${requiredPoints.toStringAsFixed(1)} points',
                              Icons.flash_on,
                              Colors.orange.shade700),
                          _buildSummaryRow(
                              l10n.estimatedCost,
                              'LKR ${estimatedCost.toStringAsFixed(2)}',
                              Icons.money,
                              colorScheme.secondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _proceedToChargingDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.payment, size: 28),
                        const SizedBox(width: 12),
                        Text(l10n.proceedToPayment),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      String title, String value, IconData icon, Color iconColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 30),
          const SizedBox(width: 18),
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
}
