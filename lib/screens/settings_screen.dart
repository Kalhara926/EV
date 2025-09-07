// lib/screens/settings_screen.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(context);

    const Map<String, String> languageMap = {
      'en': 'English',
      'si': 'සිංහල',
      'ta': 'தமிழ்',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.selectLanguage),
            trailing: DropdownButton<String>(
              value: languageProvider.locale.languageCode,
              underline: const SizedBox(),
              items: languageMap.keys.map((String code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(languageMap[code]!),
                );
              }).toList(),
              onChanged: (String? newCode) {
                if (newCode != null) {
                  languageProvider.changeLanguage(Locale(newCode));
                }
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
