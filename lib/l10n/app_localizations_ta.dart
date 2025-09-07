// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get loginTitle => 'உள்நுழை';

  @override
  String get usernameHint => 'பயனர்பெயர்';

  @override
  String get passwordHint => 'கடவுச்சொல்';

  @override
  String get rememberMe => 'என்னை நினைவில் கொள்';

  @override
  String get forgotPassword => 'கடவுச்சொல்லை மறந்தீர்களா?';

  @override
  String get orText => 'அல்லது';

  @override
  String get loginWithGoogle => 'Google மூலம் உள்நுழைக';

  @override
  String get signInWithApple => 'Apple மூலம் உள்நுழைக';

  @override
  String get newUserPrompt => ' இந்தப் பயன்பாட்டிற்கு புதியவரா? ';

  @override
  String get signUpNow => 'பதிவு செய்க';

  @override
  String get hello => 'வணக்கம்,';

  @override
  String get chargeNow => 'இப்போது சார்ஜ் செய்!';

  @override
  String get scanQrPrompt => 'சார்ஜ் செய்ய QR குறியீட்டை ஸ்கேன் செய்யவும்';

  @override
  String get yourCurrentEvPoints => 'உங்கள் EV புள்ளிகள்:';

  @override
  String get oneEvPointEquals => '1 EV புள்ளி = 1 ரூபாய்';

  @override
  String get topUp => 'Top Up';

  @override
  String get quickActions => 'விரைவு நடவடிக்கைகள்';

  @override
  String get stations => 'நிலையங்கள்';

  @override
  String get myVehicle => 'என் வாகனம்';

  @override
  String get wallet => 'Wallet';

  @override
  String get history => 'வரலாறு';

  @override
  String get chargingInProgress => 'சார்ஜ் ஆகிறது';

  @override
  String finishesAround(Object time) {
    return 'சுமார் $time மணிக்கு முடிவடையும்';
  }

  @override
  String get view => 'பார்';

  @override
  String get drawerHome => 'முகப்பு';

  @override
  String get drawerAboutUs => 'எங்களை பற்றி';

  @override
  String get drawerPrivacyPolicy => 'தனியுரிமைக் கொள்கை';

  @override
  String get drawerTerms => 'விதிமுறைகளும் நிபந்தனைகளும்';

  @override
  String get signOut => 'வெளியேறு';

  @override
  String get registrationFailed => 'பதிவு தோல்வியடைந்தது';

  @override
  String get passwordsDontMatch => 'கடவுச்சொற்கள் பொருந்தவில்லை!';

  @override
  String get createAccountTitle => 'உங்களுக்காக ஒரு கணக்கை உருவாக்குவோம்';

  @override
  String get firstNameHint => 'முதல் பெயர்';

  @override
  String get lastNameHint => 'கடைசி பெயர்';

  @override
  String get emailHint => 'மின்னஞ்சல்';

  @override
  String get confirmPasswordHint => 'கடவுச்சொல்லை உறுதிப்படுத்தவும்';

  @override
  String get signUpButton => 'பதிவு செய்க';

  @override
  String get alreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get loginNow => 'இப்போது உள்நுழையவும்';

  @override
  String get myVehiclesTitle => 'எனது வாகனங்கள்';

  @override
  String get deleteVehicleTitle => 'வாகனத்தை நீக்கு';

  @override
  String get deleteVehicleConfirm => 'இந்த வாகனத்தை நீக்க விரும்புகிறீர்களா?';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get delete => 'நீக்கு';

  @override
  String get vehicleDeleted => 'வாகனம் நீக்கப்பட்டது.';

  @override
  String errorDeletingVehicle(Object error) {
    return 'வாகனத்தை நீக்குவதில் பிழை: $error';
  }

  @override
  String get noVehiclesFound => 'வாகனங்கள் எதுவும் இல்லை!';

  @override
  String get addFirstVehiclePrompt =>
      'தொடங்குவதற்கு உங்கள் முதல் மின்சார வாகனத்தைச் சேர்க்கவும்.';

  @override
  String get addYourFirstVehicle => 'உங்கள் முதல் வாகனத்தைச் சேர்க்கவும்';

  @override
  String get addVehicle => 'வாகனத்தைச் சேர்';

  @override
  String get edit => 'திருத்து';

  @override
  String get licensePlate => 'உரிமத் தட்டு';

  @override
  String get batteryCapacity => 'மின்கலத் திறன்';

  @override
  String get chargingPort => 'சார்ஜிங் போர்ட்';

  @override
  String get addNewVehicleTitle => 'புதிய வாகனத்தைச் சேர்';

  @override
  String get editVehicleTitle => 'வாகனத்தைத் திருத்து';

  @override
  String get makeHint => 'தயாரிப்பு (எ.கா., டெஸ்லா)';

  @override
  String get modelHint => 'மாடல் (எ.கா., மாடல் 3)';

  @override
  String get yearHint => 'ஆண்டு';

  @override
  String get batteryCapacityHint => 'மின்கலத் திறன் (எ.கா., 75 kWh)';

  @override
  String get chargingPortType => 'சார்ஜிங் போர்ட் வகை';

  @override
  String get specifyOtherPort => 'பிற போர்ட் வகையைக் குறிப்பிடவும்';

  @override
  String get pleaseSelectType => 'ஒரு வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get fieldCannotBeEmpty => 'இந்தப் புலம் காலியாக இருக்கக்கூடாது';

  @override
  String get saveChanges => 'மாற்றங்களைச் சேமி';

  @override
  String get myWalletTitle => 'எனது Wallet';

  @override
  String get availableEvPoints => 'கிடைக்கும் EV புள்ளிகள்';

  @override
  String get topUpYourWallet => 'உங்கள் Wallet-ஐ Top Up செய்யவும்';

  @override
  String get enterAmountPoints => 'தொகையை (புள்ளிகள்) உள்ளிடவும்';

  @override
  String get proceedToPay => 'பணம் செலுத்த தொடரவும்';

  @override
  String get transactionHistory => 'பரிவர்த்தனை வரலாறு';

  @override
  String get viewAll => 'அனைத்தையும் காட்டு';

  @override
  String get noRecentTransactions => 'சமீபத்திய பரிவர்த்தனைகள் இல்லை.';

  @override
  String topUpSuccess(Object amount) {
    return '$amount புள்ளிகள் வெற்றிகரமாக சேர்க்கப்பட்டன!';
  }

  @override
  String topUpFailed(Object error) {
    return 'Top Up தோல்வியடைந்தது: $error';
  }

  @override
  String get pleaseEnterValidAmount => 'தயவுசெய்து சரியான தொகையை உள்ளிடவும்.';

  @override
  String get selectChargingTimeTitle => 'சார்ஜிங் நேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get connectedCharger => 'இணைக்கப்பட்ட சார்ஜர்';

  @override
  String get readyForCharging => 'சார்ஜ் செய்யத் தயார்';

  @override
  String get howLongToCharge => 'எவ்வளவு நேரம் சார்ஜ் செய்ய விரும்புகிறீர்கள்?';

  @override
  String minutes(Object count) {
    return '$count நிமிடங்கள்';
  }

  @override
  String get chargingSummary => 'சார்ஜிங் சுருக்கம்';

  @override
  String get duration => 'கால அளவு';

  @override
  String get evPointsRequired => 'தேவையான EV புள்ளிகள்';

  @override
  String get estimatedCost => 'மதிப்பிடப்பட்ட செலவு';

  @override
  String get proceedToPayment => 'பணம் செலுத்த தொடரவும்';

  @override
  String get pleaseSelectValidDuration =>
      'சரியான கால அளவைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get chargingSessionTitle => 'சார்ஜிங் அமர்வு';

  @override
  String get yourSessionDetails => 'உங்கள் அமர்வு விவரங்கள்';

  @override
  String yourAvailablePoints(Object count) {
    return 'கிடைக்கும் புள்ளிகள்: $count';
  }

  @override
  String get confirmAndPay => 'உறுதிசெய்து பணம் செலுத்து';

  @override
  String get payRemaining => 'மீதமுள்ளதை செலுத்தி தொடரவும்';

  @override
  String get startChargingNow => 'இப்போது சார்ஜ் செய்யத் தொடங்கு';

  @override
  String get chargingInProgressTitle => 'சார்ஜ் ஆகிறது';

  @override
  String get timeLeft => 'மீதமுள்ள நேரம்';

  @override
  String get volts => 'வோல்ட்ஸ்';

  @override
  String get amps => 'ஆம்ப்ஸ்';

  @override
  String get stopCharging => 'சார்ஜ் செய்வதை நிறுத்து';

  @override
  String get paymentConfirmed =>
      'பணம் செலுத்துதல் உறுதிசெய்யப்பட்டது! இப்போது நீங்கள் சார்ஜ் செய்யத் தொடங்கலாம்.';

  @override
  String paymentFailed(Object error) {
    return 'பணம் செலுத்துதல் தோல்வியடைந்தது: $error';
  }

  @override
  String get chargingStopped => 'சார்ஜ் செய்வது நிறுத்தப்பட்டது.';

  @override
  String get chargingComplete => 'சார்ஜிங் முடிந்தது!';

  @override
  String get profileTitle => 'சுயவிவரம்';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get language => 'மொழி';

  @override
  String get selectLanguage =>
      'உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get customerSupport => 'வாடிக்கையாளர் ஆதரவு';

  @override
  String get callHotline => 'எங்கள் ஹாட்லைனை அழைக்கவும்';

  @override
  String get ourAddress => 'எங்கள் முகவரி';

  @override
  String get addressLine => 'இல. 123, காலி வீதி, கொழும்பு 03, இலங்கை';

  @override
  String get sendFeedback => 'கருத்து அல்லது புகாரை அனுப்பவும்';

  @override
  String get feedbackHint => 'உங்கள் செய்தியை இங்கே தட்டச்சு செய்யவும்...';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get feedbackSuccess => 'கருத்து வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது!';

  @override
  String feedbackFailed(Object error) {
    return 'கருத்தை சமர்ப்பிக்கத் தவறிவிட்டது: $error';
  }

  @override
  String get mobileNumberHint => 'மொபைல் எண்';

  @override
  String get profileUpdatedSuccess =>
      'சுயவிவரம் வெற்றிகரமாகப் புதுப்பிக்கப்பட்டது!';

  @override
  String profileUpdateFailed(Object error) {
    return 'சுயவிவரத்தைப் புதுப்பிக்கத் தவறிவிட்டது: $error';
  }

  @override
  String get tapToChange => 'மாற்ற படத்தை தட்டவும்';

  @override
  String get signUpTitle => 'பதிவு செய்க';

  @override
  String get personal => 'தனிப்பட்ட';

  @override
  String get security => 'பாதுகாப்பு';

  @override
  String get company => 'நிறுவனம்';

  @override
  String get country => 'நாடு';

  @override
  String get companyName => 'நிறுவனத்தின் பெயர்';

  @override
  String get sriLanka => 'இலங்கை';

  @override
  String get chargeNetPlus => 'chargeNET+';

  @override
  String get findStationsTitle => 'நிலையங்களைக் கண்டறியவும்';

  @override
  String stationsNearYou(Object distance) {
    return 'உங்களுக்கு அருகிலுள்ள நிலையங்கள் (${distance}km)';
  }

  @override
  String noStationsNearby(Object distance) {
    return '${distance}km சுற்றளவில் நிலையங்கள் எதுவும் இல்லை.';
  }

  @override
  String get getDirections => 'திசைகளைப் பெறுக';

  @override
  String get chargingHistoryTitle => 'சார்ஜிங் வரலாறு';

  @override
  String get noChargingHistory => 'இன்னும் சார்ஜிங் வரலாறு இல்லை!';

  @override
  String get pastSessionsAppearHere =>
      'உங்கள் கடந்தகால சார்ஜிங் அமர்வுகள் இங்கே தோன்றும்.';

  @override
  String get startNewCharge => 'புதிய சார்ஜிங்கைத் தொடங்கு';

  @override
  String get energy => 'ஆற்றல்';

  @override
  String get cost => 'செலவு';
}
