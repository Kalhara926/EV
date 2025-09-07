// lib/main.dart

import 'package:ev_charging_app/l10n/app_localizations.dart';
import 'package:ev_charging_app/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ev_charging_app/providers/user_profile_provider.dart';
import 'package:ev_charging_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ev_charging_app/firebase_options.dart';
import 'package:ev_charging_app/utils/app_theme.dart'; // --- ನಮ್ಮ ಹೊಸ ಥೀಮ್ ಫೈಲ್ ಅನ್ನು ಆಮದು ಮಾಡಿ ---

// ಲೊಕಲೈಸೇಶನ್‌ಗಾಗಿ ಆಮದುಗಳು
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'EV Charging App',
      debugShowCheckedModeBanner: false,

      // --- ಇಲ್ಲಿ ಬದಲಾವಣೆ: ನಮ್ಮ ಹೊಸ ಥೀಮ್ ಅನ್ನು ಅನ್ವಯಿಸಿ ---
      theme: AppTheme.getAppTheme(),

      // --- ಲೊಕಲೈಸೇಶನ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳು ---
      locale: languageProvider.locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('si', ''),
        Locale('ta', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const SplashScreen(),
    );
  }
}
