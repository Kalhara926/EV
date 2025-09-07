// lib/screens/splash_screen.dart

import 'package:ev_charging_app/auth/auth_gate.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation; // Color fill animation
  late Animation<double> _textFadeAnimation; // Text fade-in animation
  late Animation<double> _pulseAnimation; // Final pulse animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Total animation time
    );

    // Color fill animation (from 0s to 2s)
    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    // Text fade-in animation (from 1.5s to 2.5s)
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.375, 0.625, curve: Curves.easeIn)),
    );

    // Final pulse animation (from 2.5s to 3.5s)
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.625, 0.875, curve: Curves.easeInOut)),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface, // Clean white background
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // This Stack will create the fill effect
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // The outline is always visible
                      Image.asset('assets/images/logo_outline.png', width: 500),

                      // The fill is revealed using a ClipPath
                      ClipPath(
                        clipper: _LogoFillClipper(_fillAnimation.value),
                        child: Image.asset('assets/images/logo_fill.png',
                            width: 500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // The text fades in
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child:
                        Image.asset('assets/images/logo_text.png', width: 250),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom Clipper to create the "filling up" effect
class _LogoFillClipper extends CustomClipper<Path> {
  final double progress; // 0.0 to 1.0

  _LogoFillClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    // Clip from bottom to top
    path.addRect(Rect.fromLTWH(
        0, size.height * (1 - progress), size.width, size.height * progress));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
