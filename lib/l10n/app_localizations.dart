import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @newUserPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to this app? '**
  String get newUserPrompt;

  /// No description provided for @signUpNow.
  ///
  /// In en, this message translates to:
  /// **'Sign-Up'**
  String get signUpNow;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @chargeNow.
  ///
  /// In en, this message translates to:
  /// **'Charge Now!'**
  String get chargeNow;

  /// No description provided for @scanQrPrompt.
  ///
  /// In en, this message translates to:
  /// **'Scan QR to start your charging session'**
  String get scanQrPrompt;

  /// No description provided for @yourCurrentEvPoints.
  ///
  /// In en, this message translates to:
  /// **'Your Current EV Points:'**
  String get yourCurrentEvPoints;

  /// No description provided for @oneEvPointEquals.
  ///
  /// In en, this message translates to:
  /// **'1 EV Point = 1 Rupee'**
  String get oneEvPointEquals;

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @stations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get stations;

  /// No description provided for @myVehicle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get myVehicle;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @chargingInProgress.
  ///
  /// In en, this message translates to:
  /// **'CHARGING IN PROGRESS'**
  String get chargingInProgress;

  /// No description provided for @finishesAround.
  ///
  /// In en, this message translates to:
  /// **'Finishes around {time}'**
  String finishesAround(Object time);

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @drawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerHome;

  /// No description provided for @drawerAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get drawerAboutUs;

  /// No description provided for @drawerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get drawerPrivacyPolicy;

  /// No description provided for @drawerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get drawerTerms;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registrationFailed;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match!'**
  String get passwordsDontMatch;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s create an account for you'**
  String get createAccountTitle;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get loginNow;

  /// No description provided for @myVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehiclesTitle;

  /// No description provided for @deleteVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get deleteVehicleTitle;

  /// No description provided for @deleteVehicleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle?'**
  String get deleteVehicleConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @vehicleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted.'**
  String get vehicleDeleted;

  /// No description provided for @errorDeletingVehicle.
  ///
  /// In en, this message translates to:
  /// **'Error deleting vehicle: {error}'**
  String errorDeletingVehicle(Object error);

  /// No description provided for @noVehiclesFound.
  ///
  /// In en, this message translates to:
  /// **'No vehicles found!'**
  String get noVehiclesFound;

  /// No description provided for @addFirstVehiclePrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your first EV to get started.'**
  String get addFirstVehiclePrompt;

  /// No description provided for @addYourFirstVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Vehicle'**
  String get addYourFirstVehicle;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @licensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// No description provided for @batteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'Battery Capacity'**
  String get batteryCapacity;

  /// No description provided for @chargingPort.
  ///
  /// In en, this message translates to:
  /// **'Charging Port'**
  String get chargingPort;

  /// No description provided for @addNewVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Vehicle'**
  String get addNewVehicleTitle;

  /// No description provided for @editVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get editVehicleTitle;

  /// No description provided for @makeHint.
  ///
  /// In en, this message translates to:
  /// **'Make (e.g., Tesla)'**
  String get makeHint;

  /// No description provided for @modelHint.
  ///
  /// In en, this message translates to:
  /// **'Model (e.g., Model 3)'**
  String get modelHint;

  /// No description provided for @yearHint.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearHint;

  /// No description provided for @batteryCapacityHint.
  ///
  /// In en, this message translates to:
  /// **'Battery Capacity (e.g., 75 kWh)'**
  String get batteryCapacityHint;

  /// No description provided for @chargingPortType.
  ///
  /// In en, this message translates to:
  /// **'Charging Port Type'**
  String get chargingPortType;

  /// No description provided for @specifyOtherPort.
  ///
  /// In en, this message translates to:
  /// **'Specify Other Port Type'**
  String get specifyOtherPort;

  /// No description provided for @pleaseSelectType.
  ///
  /// In en, this message translates to:
  /// **'Please select a type'**
  String get pleaseSelectType;

  /// No description provided for @fieldCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get fieldCannotBeEmpty;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @myWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWalletTitle;

  /// No description provided for @availableEvPoints.
  ///
  /// In en, this message translates to:
  /// **'Available EV Points'**
  String get availableEvPoints;

  /// No description provided for @topUpYourWallet.
  ///
  /// In en, this message translates to:
  /// **'Top Up Your Wallet'**
  String get topUpYourWallet;

  /// No description provided for @enterAmountPoints.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount (Points)'**
  String get enterAmountPoints;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Pay'**
  String get proceedToPay;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions.'**
  String get noRecentTransactions;

  /// No description provided for @topUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'{amount} points added successfully!'**
  String topUpSuccess(Object amount);

  /// No description provided for @topUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to top up: {error}'**
  String topUpFailed(Object error);

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount.'**
  String get pleaseEnterValidAmount;

  /// No description provided for @selectChargingTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Charging Time'**
  String get selectChargingTimeTitle;

  /// No description provided for @connectedCharger.
  ///
  /// In en, this message translates to:
  /// **'Connected Charger'**
  String get connectedCharger;

  /// No description provided for @readyForCharging.
  ///
  /// In en, this message translates to:
  /// **'Ready for charging'**
  String get readyForCharging;

  /// No description provided for @howLongToCharge.
  ///
  /// In en, this message translates to:
  /// **'How long do you want to charge?'**
  String get howLongToCharge;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} Minutes'**
  String minutes(Object count);

  /// No description provided for @chargingSummary.
  ///
  /// In en, this message translates to:
  /// **'Charging Summary'**
  String get chargingSummary;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @evPointsRequired.
  ///
  /// In en, this message translates to:
  /// **'EV Points Required'**
  String get evPointsRequired;

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get estimatedCost;

  /// No description provided for @proceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get proceedToPayment;

  /// No description provided for @pleaseSelectValidDuration.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid duration.'**
  String get pleaseSelectValidDuration;

  /// No description provided for @chargingSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Charging Session'**
  String get chargingSessionTitle;

  /// No description provided for @yourSessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Your Session Details'**
  String get yourSessionDetails;

  /// No description provided for @yourAvailablePoints.
  ///
  /// In en, this message translates to:
  /// **'Your Available Points: {count}'**
  String yourAvailablePoints(Object count);

  /// No description provided for @confirmAndPay.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Pay'**
  String get confirmAndPay;

  /// No description provided for @payRemaining.
  ///
  /// In en, this message translates to:
  /// **'Pay Remaining to Proceed'**
  String get payRemaining;

  /// No description provided for @startChargingNow.
  ///
  /// In en, this message translates to:
  /// **'Start Charging Now'**
  String get startChargingNow;

  /// No description provided for @chargingInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Charging in Progress'**
  String get chargingInProgressTitle;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get timeLeft;

  /// No description provided for @volts.
  ///
  /// In en, this message translates to:
  /// **'Volts'**
  String get volts;

  /// No description provided for @amps.
  ///
  /// In en, this message translates to:
  /// **'Amps'**
  String get amps;

  /// No description provided for @stopCharging.
  ///
  /// In en, this message translates to:
  /// **'Stop Charging'**
  String get stopCharging;

  /// No description provided for @paymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmed! You can now start charging.'**
  String get paymentConfirmed;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed: {error}'**
  String paymentFailed(Object error);

  /// No description provided for @chargingStopped.
  ///
  /// In en, this message translates to:
  /// **'Charging stopped.'**
  String get chargingStopped;

  /// No description provided for @chargingComplete.
  ///
  /// In en, this message translates to:
  /// **'Charging Complete!'**
  String get chargingComplete;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get selectLanguage;

  /// No description provided for @customerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupport;

  /// No description provided for @callHotline.
  ///
  /// In en, this message translates to:
  /// **'Call Our Hotline'**
  String get callHotline;

  /// No description provided for @ourAddress.
  ///
  /// In en, this message translates to:
  /// **'Our Address'**
  String get ourAddress;

  /// No description provided for @addressLine.
  ///
  /// In en, this message translates to:
  /// **'No. 123, Galle Road, Colombo 03, Sri Lanka'**
  String get addressLine;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback or Complaint'**
  String get sendFeedback;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get feedbackHint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @feedbackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully!'**
  String get feedbackSuccess;

  /// No description provided for @feedbackFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit feedback: {error}'**
  String feedbackFailed(Object error);

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumberHint;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String profileUpdateFailed(Object error);

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap image to change'**
  String get tapToChange;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign-Up'**
  String get signUpTitle;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @sriLanka.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get sriLanka;

  /// No description provided for @chargeNetPlus.
  ///
  /// In en, this message translates to:
  /// **'chargeNET+'**
  String get chargeNetPlus;

  /// No description provided for @findStationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Stations'**
  String get findStationsTitle;

  /// No description provided for @stationsNearYou.
  ///
  /// In en, this message translates to:
  /// **'Stations Near You ({distance}km)'**
  String stationsNearYou(Object distance);

  /// No description provided for @noStationsNearby.
  ///
  /// In en, this message translates to:
  /// **'No stations found within {distance}km radius.'**
  String noStationsNearby(Object distance);

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @chargingHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Charging History'**
  String get chargingHistoryTitle;

  /// No description provided for @noChargingHistory.
  ///
  /// In en, this message translates to:
  /// **'No Charging History Yet!'**
  String get noChargingHistory;

  /// No description provided for @pastSessionsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your past charging sessions will appear here.'**
  String get pastSessionsAppearHere;

  /// No description provided for @startNewCharge.
  ///
  /// In en, this message translates to:
  /// **'Start a New Charge'**
  String get startNewCharge;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
