// lib/screens/customer_support_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '0769965517');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showSnackBar('Could not make the call.', isError: true);
    }
  }

  Future<void> _submitFeedback() async {
    final l10n = AppLocalizations.of(context)!;
    if (_feedbackController.text.trim().isEmpty) {
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar('You must be logged in to submit feedback.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'message': _feedbackController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      _feedbackController.clear();
      _showSnackBar(l10n.feedbackSuccess);
    } catch (e) {
      _showSnackBar(l10n.feedbackFailed(e.toString()), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Theme.of(context).colorScheme.error : Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerSupport),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Call Button
            Card(
              child: ListTile(
                leading: Icon(Icons.call,
                    color: theme.colorScheme.primary, size: 30),
                title:
                    Text(l10n.callHotline, style: theme.textTheme.titleLarge),
                subtitle: const Text("076 996 5517"),
                onTap: _makePhoneCall,
              ),
            ),
            const SizedBox(height: 20),

            // Address Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.ourAddress, style: theme.textTheme.titleLarge),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: theme.colorScheme.secondary),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(l10n.addressLine,
                                style: theme.textTheme.bodyLarge)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Feedback Form
            Text(l10n.sendFeedback, style: theme.textTheme.titleLarge),
            const SizedBox(height: 15),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.feedbackHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitFeedback,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: Text(l10n.submit),
            ),
          ],
        ),
      ),
    );
  }
}
