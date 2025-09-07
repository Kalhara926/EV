// lib/screens/emergency_call_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// --- වෙනස #1: Data Model එකක් නිර්මාණය කිරීම ---
// හැම contact එකකම තොරතුරු පිළිවෙලකට තියාගන්න පොඩි class එකක් හදනවා.
class EmergencyContact {
  final String name;
  final String phoneNumber;
  final IconData icon;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.icon,
  });
}

class EmergencyCallScreen extends StatefulWidget {
  const EmergencyCallScreen({super.key});

  @override
  State<EmergencyCallScreen> createState() => _EmergencyCallScreenState();
}

class _EmergencyCallScreenState extends State<EmergencyCallScreen> {
  // --- වෙනස #2: Company List එක මෙතන හදාගන්නවා ---
  // ඔයාට ඕන තරම් companies මෙතනට එකතු කරන්න/අයින් කරන්න පුළුවන්.
  // වැදගත්: මේ numbers උදාහරණ විතරයි. ඔයා හරි numbers දාන්න ඕනේ.
  final List<EmergencyContact> companyContacts = [
    EmergencyContact(
      name: 'ChargeNET Support',
      phoneNumber: '0117888888', // <-- හරි number එක දාන්න
      icon: Icons.ev_station,
    ),
    EmergencyContact(
      name: 'VEGA Innovations',
      phoneNumber: '0112345678', // <-- හරි number එක දාන්න
      icon: Icons.electric_car,
    ),
    EmergencyContact(
      name: 'Tesla Roadside Assistance',
      phoneNumber: '18777983752', // <-- හරි number එක දාන්න
      icon: Icons.car_repair,
    ),
    EmergencyContact(
      name: 'Generic Roadside Help',
      phoneNumber: '111222333', // <-- හරි number එක දාන්න
      icon: Icons.support_agent,
    ),
  ];

  // --- වෙනස #3: Phone call function එක පොදු කරනවා ---
  // දැන් මේ function එකට දෙන ඕනම number එකකට call එකක් ගන්න පුළුවන්.
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not call $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- වෙනස #4: UI එක සම්පූර්ණයෙන්ම අලුතෙන් හදනවා ---
      appBar: AppBar(
        title: const Text('Emergency Support'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. ප්‍රධාන හදිසි ඇමතුම් කොටස
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE9E7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'General Emergency',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For immediate police or medical emergencies, use this button.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _makePhoneCall('119'), // 119 ට call එක යනවා
                      icon: const Icon(Icons.call, color: Colors.white),
                      label: const Text(
                        'CALL 119 NOW',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. EV සමාගම් වල List එක පටන් ගන්න තැන
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'EV Company Hotlines',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 3. සමාගම් වල List එක හදනවා
              ListView.builder(
                shrinkWrap:
                    true, // මේක SingleChildScrollView එකක් ඇතුලේ නිසා ඕනේ
                physics:
                    const NeverScrollableScrollPhysics(), // Scroll එක disable කරනවා
                itemCount: companyContacts.length,
                itemBuilder: (context, index) {
                  final contact = companyContacts[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(contact.icon,
                            color: Theme.of(context).primaryColor),
                      ),
                      title: Text(
                        contact.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(contact.phoneNumber),
                      trailing:
                          const Icon(Icons.call_made, color: Colors.green),
                      onTap: () => _makePhoneCall(
                          contact.phoneNumber), // අදාළ number එකට call එක යනවා
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
