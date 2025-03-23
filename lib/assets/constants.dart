import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';

// --- Env --- //

/// Whether we are currently running tests
bool testMode = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

/// Whether the app is currently running in debug mode
bool devMode = !testMode && !kReleaseMode;

const LOCAL_CAUSES_API_URL = '192.168.1.65:3001';
const LOCAL_STACK_URL = 'http://192.168.1.11';

// devMode ? "staging.api.now-u.com" : "api.now-u.com";

const CAUSES_API_URL = 'https://causes.dev.apiv2.now-u.com/';
// const CAUSES_API_URL = '$LOCAL_STACK_URL:8000';

// const SEARCH_SERVICE_URL = '$LOCAL_STACK_URL:7700';
const SEARCH_SERVICE_URL = 'https://search.dev.apiv2.now-u.com';

// Key uid: c41c4e65-0b7e-468b-b346-4f277cc9e8b7
const SEARCH_SERVICE_KEY =
    'aaae5a4efcd407ca2c568ad9bcafda8f5362526a4b14ab8d746df52a7e7415a6';

final PRIVACY_POLICY_URI =
    Uri.parse('https://www.now-u.com/info/privacy-notice');
final TERMS_AND_CONDITIONS_URI = Uri.parse(
  'https://www.now-u.com/info/terms-and-conditions-for-users',
);

final ABOUT_US_URI = Uri.parse('https://www.now-u.com/about');
final FEEDBACK_FORM_URI = Uri.parse('https://www.now-u.com/app/feedback');
final JOIN_RESEARCH_FORM_URI = Uri.parse(
  'https://www.now-u.com/app/research/signup',
);

final INSTAGRAM_URI = Uri.parse('https://www.instagram.com/now_u_app/');
final FACEBOOK_URI = Uri.parse('https://www.facebook.com/nowufb');
final X_TWITTER_URI = Uri.parse('https://x.com/now_u_app');
final FACEBOOK_MESSENGER_URI = Uri.parse('http://m.me/nowufb');
final EMAIL_MAILTO_URI = Uri.parse('mailto:hello@now-u.com?subject=Hi');

final APPLE_APP_STORE_URI =
    Uri.parse('https://apps.apple.com/us/app/now-u/id1516126639');
final GOOGLE_APP_STORE_URI =
    Uri.parse('https://play.google.com/store/apps/details?id=com.nowu.app');

class CustomColors {
  /// Primary brand color
  static Color brandColor = const Color.fromRGBO(255, 136, 0, 1);

  // --- Styles --- //

  //-- Accent colours --//
  /// Venetian Red
  static Color accentRed = const Color.fromRGBO(211, 0, 1, 1);

  /// Sunflower
  static Color accentYellow = const Color.fromRGBO(243, 183, 0, 1);

  /// Salomie
  static Color accentLightYellow = const Color.fromRGBO(243, 183, 0, 1);

  /// Oxford Blue
  static Color accentBlue = const Color.fromRGBO(1, 26, 67, 1);

  //-- Neutrals --//
  static Color white = Colors.white;
  static Color greyLight1 = const Color.fromRGBO(247, 248, 252, 1);
  static Color greyLight2 = const Color.fromRGBO(222, 224, 232, 1);
  static Color greyMed1 = const Color.fromRGBO(189, 192, 205, 1);
  static Color greyDark1 = const Color.fromRGBO(155, 159, 177, 1);
  static Color greyDark2 = const Color.fromRGBO(109, 113, 129, 1);
  static Color black1 = const Color.fromRGBO(55, 58, 74, 1);
  static Color black2 = const Color.fromRGBO(23, 23, 26, 1);

  //-- Background --//
  static Color lightOrange = const Color.fromRGBO(255, 243, 230, 0.5);

//-- Shadow colors --//
}

class CustomFontSize {
  static double heading1 = 36;
  static double heading2 = 30;
  static double heading3 = 24;
  static double heading4 = 18;
  static double heading5 = 16;
  static double body = 16;
}

class CustomPaddingSize {
  static const double xsmall = 8;
  static const double small = 14;
  static const double normal = 20;
  static const double large = 40;
}
