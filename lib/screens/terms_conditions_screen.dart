import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Icon and Title Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Column(
                children: [
                  Icon(Icons.article_outlined,
                      size: 80, color: Colors.blueAccent),
                  SizedBox(height: 10),
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Terms Content Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Welcome to EV Charging App! These terms and conditions outline the rules and regulations for the use of our mobile application and services.\n\n'
                'By accessing this app, we assume you accept these terms and conditions. Do not continue to use the EV Charging App if you do not agree to take all of the terms and conditions stated on this page.\n\n'
                'You must not:\n- Republish material\n- Sell or sub-license material\n- Reproduce or copy material\n\n'
                'We reserve the right to modify these terms at any time, and your continued use of the app signifies your acceptance of any updated terms.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
