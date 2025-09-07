// lib/screens/qr_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_charging_app/screens/time_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  final DatabaseReference rtdbRef = FirebaseDatabase.instance.ref();

  bool _isProcessing = false;
  String _feedbackMessage = 'Align QR code within the frame';
  Color _feedbackColor = Colors.white;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    rtdbRef.child('QR').set(0);
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onBarcodeDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final String? scannedCode = capture.barcodes.firstOrNull?.rawValue;
    if (scannedCode != null) {
      debugPrint("--- SCANNED RAW DATA: [$scannedCode] ---");
      cameraController.stop();
      setState(() {
        _isProcessing = true;
        _feedbackMessage = 'Verifying Charger ID...';
        _feedbackColor = Colors.lightBlueAccent;
      });
      _verifyChargerId(scannedCode);
    }
  }

  Future<void> _verifyChargerId(String chargerId) async {
    if (FirebaseAuth.instance.currentUser == null) {
      _handleError("Authentication Error: Please login first.");
      return;
    }
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('chargers')
          .doc(chargerId.trim())
          .get();

      if (docSnapshot.exists) {
        final chargerData = docSnapshot.data() as Map<String, dynamic>;

        // --- මෙන්න වෙනස: 'station_name' -> 'location_name' ---
        // Firebase එකේ තියෙන 'location_name' field එක කියවනවා
        final stationName = chargerData['location_name'] ?? 'Unknown Station';

        await rtdbRef.child('QR').set(1);

        setState(() {
          _feedbackMessage = 'Charger Verified! Redirecting...';
          _feedbackColor = Colors.greenAccent;
        });
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TimeSelectionScreen(
                chargerId: chargerId.trim(),
                stationName: stationName,
              ),
            ),
          );
        }
      } else {
        _handleError(
            "Invalid QR: No charger found with ID [${chargerId.trim()}]");
      }
    } catch (e) {
      _handleError("Error: ${e.toString()}");
      debugPrint("Firebase Verification Error: $e");
    }
  }

  Future<void> _handleError(String errorMessage) async {
    await rtdbRef.child('QR').set(0);

    setState(() {
      _feedbackMessage = errorMessage;
      _feedbackColor = Colors.redAccent;
    });
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      setState(() {
        _feedbackMessage = 'Align QR code within the frame';
        _feedbackColor = Colors.white;
        _isProcessing = false;
      });
      cameraController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan to Charge'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onBarcodeDetect,
          ),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(color: Colors.transparent)),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(0, -1 + (_animation.value * 2)),
                  child: Container(
                    width: double.infinity,
                    height: 2,
                    decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.lightBlueAccent,
                            blurRadius: 10,
                            spreadRadius: 2)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _feedbackMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _feedbackColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
