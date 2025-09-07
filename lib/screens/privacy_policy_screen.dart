import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Icon/Image Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Column(
                children: [
                  // Replace with actual asset or network image
                  Icon(Icons.verified_user, size: 80, color: Colors.green),
                  SizedBox(height: 10),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.\n\n'
                'We collect information to provide better services to all our users. We may collect information like name, email, and location for service optimization.\n\n'
                'We do not share personal information with companies, organizations, or individuals outside of our app unless one of the following circumstances applies: with your consent, for legal reasons, or for external processing with trusted partners.\n\n'
                'By using our services, you agree to this Privacy Policy.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
