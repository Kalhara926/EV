// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get usernameHint => 'Username';

  @override
  String get passwordHint => 'Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get orText => 'OR';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get newUserPrompt => 'New to this app? ';

  @override
  String get signUpNow => 'Sign-Up';

  @override
  String get hello => 'Hello,';

  @override
  String get chargeNow => 'Charge Now!';

  @override
  String get scanQrPrompt => 'Scan QR to start your charging session';

  @override
  String get yourCurrentEvPoints => 'Your Current EV Points:';

  @override
  String get oneEvPointEquals => '1 EV Point = 1 Rupee';

  @override
  String get topUp => 'Top Up';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get stations => 'Stations';

  @override
  String get myVehicle => 'My Vehicle';

  @override
  String get wallet => 'Wallet';

  @override
  String get history => 'History';

  @override
  String get chargingInProgress => 'CHARGING IN PROGRESS';

  @override
  String finishesAround(Object time) {
    return 'Finishes around $time';
  }

  @override
  String get view => 'View';

  @override
  String get drawerHome => 'Home';

  @override
  String get drawerAboutUs => 'About Us';

  @override
  String get drawerPrivacyPolicy => 'Privacy Policy';

  @override
  String get drawerTerms => 'Terms and Conditions';

  @override
  String get signOut => 'Sign Out';

  @override
  String get registrationFailed => 'Registration Failed';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match!';

  @override
  String get createAccountTitle => 'Let\'s create an account for you';

  @override
  String get firstNameHint => 'First Name';

  @override
  String get lastNameHint => 'Last Name';

  @override
  String get emailHint => 'Email';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get loginNow => 'Login now';

  @override
  String get myVehiclesTitle => 'My Vehicles';

  @override
  String get deleteVehicleTitle => 'Delete Vehicle';

  @override
  String get deleteVehicleConfirm =>
      'Are you sure you want to delete this vehicle?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get vehicleDeleted => 'Vehicle deleted.';

  @override
  String errorDeletingVehicle(Object error) {
    return 'Error deleting vehicle: $error';
  }

  @override
  String get noVehiclesFound => 'No vehicles found!';

  @override
  String get addFirstVehiclePrompt => 'Add your first EV to get started.';

  @override
  String get addYourFirstVehicle => 'Add Your First Vehicle';

  @override
  String get addVehicle => 'Add Vehicle';

  @override
  String get edit => 'Edit';

  @override
  String get licensePlate => 'License Plate';

  @override
  String get batteryCapacity => 'Battery Capacity';

  @override
  String get chargingPort => 'Charging Port';

  @override
  String get addNewVehicleTitle => 'Add New Vehicle';

  @override
  String get editVehicleTitle => 'Edit Vehicle';

  @override
  String get makeHint => 'Make (e.g., Tesla)';

  @override
  String get modelHint => 'Model (e.g., Model 3)';

  @override
  String get yearHint => 'Year';

  @override
  String get batteryCapacityHint => 'Battery Capacity (e.g., 75 kWh)';

  @override
  String get chargingPortType => 'Charging Port Type';

  @override
  String get specifyOtherPort => 'Specify Other Port Type';

  @override
  String get pleaseSelectType => 'Please select a type';

  @override
  String get fieldCannotBeEmpty => 'This field cannot be empty';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get myWalletTitle => 'My Wallet';

  @override
  String get availableEvPoints => 'Available EV Points';

  @override
  String get topUpYourWallet => 'Top Up Your Wallet';

  @override
  String get enterAmountPoints => 'Enter Amount (Points)';

  @override
  String get proceedToPay => 'Proceed to Pay';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get viewAll => 'View All';

  @override
  String get noRecentTransactions => 'No recent transactions.';

  @override
  String topUpSuccess(Object amount) {
    return '$amount points added successfully!';
  }

  @override
  String topUpFailed(Object error) {
    return 'Failed to top up: $error';
  }

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount.';

  @override
  String get selectChargingTimeTitle => 'Select Charging Time';

  @override
  String get connectedCharger => 'Connected Charger';

  @override
  String get readyForCharging => 'Ready for charging';

  @override
  String get howLongToCharge => 'How long do you want to charge?';

  @override
  String minutes(Object count) {
    return '$count Minutes';
  }

  @override
  String get chargingSummary => 'Charging Summary';

  @override
  String get duration => 'Duration';

  @override
  String get evPointsRequired => 'EV Points Required';

  @override
  String get estimatedCost => 'Estimated Cost';

  @override
  String get proceedToPayment => 'Proceed to Payment';

  @override
  String get pleaseSelectValidDuration => 'Please select a valid duration.';

  @override
  String get chargingSessionTitle => 'Charging Session';

  @override
  String get yourSessionDetails => 'Your Session Details';

  @override
  String yourAvailablePoints(Object count) {
    return 'Your Available Points: $count';
  }

  @override
  String get confirmAndPay => 'Confirm & Pay';

  @override
  String get payRemaining => 'Pay Remaining to Proceed';

  @override
  String get startChargingNow => 'Start Charging Now';

  @override
  String get chargingInProgressTitle => 'Charging in Progress';

  @override
  String get timeLeft => 'Time Left';

  @override
  String get volts => 'Volts';

  @override
  String get amps => 'Amps';

  @override
  String get stopCharging => 'Stop Charging';

  @override
  String get paymentConfirmed =>
      'Payment Confirmed! You can now start charging.';

  @override
  String paymentFailed(Object error) {
    return 'Payment Failed: $error';
  }

  @override
  String get chargingStopped => 'Charging stopped.';

  @override
  String get chargingComplete => 'Charging Complete!';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select your preferred language';

  @override
  String get customerSupport => 'Customer Support';

  @override
  String get callHotline => 'Call Our Hotline';

  @override
  String get ourAddress => 'Our Address';

  @override
  String get addressLine => 'No. 123, Galle Road, Colombo 03, Sri Lanka';

  @override
  String get sendFeedback => 'Send Feedback or Complaint';

  @override
  String get feedbackHint => 'Type your message here...';

  @override
  String get submit => 'Submit';

  @override
  String get feedbackSuccess => 'Feedback submitted successfully!';

  @override
  String feedbackFailed(Object error) {
    return 'Failed to submit feedback: $error';
  }

  @override
  String get mobileNumberHint => 'Mobile Number';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String profileUpdateFailed(Object error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get tapToChange => 'Tap image to change';

  @override
  String get signUpTitle => 'Sign-Up';

  @override
  String get personal => 'Personal';

  @override
  String get security => 'Security';

  @override
  String get company => 'Company';

  @override
  String get country => 'Country';

  @override
  String get companyName => 'Company Name';

  @override
  String get sriLanka => 'Sri Lanka';

  @override
  String get chargeNetPlus => 'chargeNET+';

  @override
  String get findStationsTitle => 'Find Stations';

  @override
  String stationsNearYou(Object distance) {
    return 'Stations Near You (${distance}km)';
  }

  @override
  String noStationsNearby(Object distance) {
    return 'No stations found within ${distance}km radius.';
  }

  @override
  String get getDirections => 'Get Directions';

  @override
  String get chargingHistoryTitle => 'Charging History';

  @override
  String get noChargingHistory => 'No Charging History Yet!';

  @override
  String get pastSessionsAppearHere =>
      'Your past charging sessions will appear here.';

  @override
  String get startNewCharge => 'Start a New Charge';

  @override
  String get energy => 'Energy';

  @override
  String get cost => 'Cost';
}
