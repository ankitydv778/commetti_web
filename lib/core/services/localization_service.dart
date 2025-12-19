import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  late Map<String, dynamic> _localizedStrings;
  Locale _currentLocale = const Locale('en', 'US');

  final Map<String, String> _supportedLanguages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'pa': 'ਪੰਜਾਬੀ',
    'kn': 'ಕನ್ನಡ',
  };

  Map<String, String> get supportedLanguages => _supportedLanguages;
  Locale get currentLocale => _currentLocale;

  Future<void> initialize() async {
    await loadLanguage(_currentLocale);
  }

  Future<void> loadLanguage(Locale locale) async {
    String langCode = locale.languageCode;

    if (!_supportedLanguages.containsKey(langCode)) {
      langCode = 'en';
    }

    String jsonString = await rootBundle.loadString(
      'assets/locales/$langCode.json',
    );
    _localizedStrings = json.decode(jsonString);
    _currentLocale = locale;
  }

  String translate(String key) {
    try {
      List<String> keys = key.split('.');
      dynamic value = _localizedStrings;

      for (String k in keys) {
        if (value is Map<String, dynamic>) {
          value = value[k];
        } else {
          return key;
        }
      }

      return value?.toString() ?? key;
    } catch (e) {
      return key;
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_supportedLanguages.containsKey(languageCode)) {
      await loadLanguage(Locale(languageCode));
    }
  }

  bool isCurrentLanguage(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }
}

// JSON files structure (create these in assets/locales/)

// en.json
/*
{
  "appName": "Chit Fund App",
  "welcome": "Welcome",
  "welcomeBack": "Welcome Back",
  "loginToContinue": "Login to continue",
  "email": "Email",
  "enterEmail": "Enter your email",
  "password": "Password",
  "enterPassword": "Enter your password",
  "login": "Login",
  "register": "Register",
  "forgotPassword": "Forgot Password?",
  "noAccount": "Don't have an account?",
  "haveAccount": "Already have an account?",
  "or": "OR"
}
*/

// hi.json
/*
{
  "appName": "चिट फंड ऐप",
  "welcome": "स्वागत है",
  "welcomeBack": "वापसी पर स्वागत है",
  "loginToContinue": "जारी रखने के लिए लॉगिन करें",
  "email": "ईमेल",
  "enterEmail": "अपना ईमेल दर्ज करें",
  "password": "पासवर्ड",
  "enterPassword": "अपना पासवर्ड दर्ज करें",
  "login": "लॉगिन",
  "register": "पंजीकरण",
  "forgotPassword": "पासवर्ड भूल गए?",
  "noAccount": "खाता नहीं है?",
  "haveAccount": "पहले से ही एक खाता है?",
  "or": "या"
}
*/

// pa.json
/*
{
  "appName": "ਚਿੱਟ ਫੰਡ ਐਪ",
  "welcome": "ਜੀ ਆਇਆਂ ਨੂੰ",
  "welcomeBack": "ਵਾਪਸੀ ਤੇ ਜੀ ਆਇਆਂ ਨੂੰ",
  "loginToContinue": "ਜਾਰੀ ਰੱਖਣ ਲਈ ਲੌਗਇਨ ਕਰੋ",
  "email": "ਈਮੇਲ",
  "enterEmail": "ਆਪਣਾ ਈਮੇਲ ਦਰਜ ਕਰੋ",
  "password": "ਪਾਸਵਰਡ",
  "enterPassword": "ਆਪਣਾ ਪਾਸਵਰਡ ਦਰਜ ਕਰੋ",
  "login": "ਲੌਗਇਨ",
  "register": "ਰਜਿਸਟਰ",
  "forgotPassword": "ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?",
  "noAccount": "ਖਾਤਾ ਨਹੀਂ ਹੈ?",
  "haveAccount": "ਪਹਿਲਾਂ ਤੋਂ ਹੀ ਇੱਕ ਖਾਤਾ ਹੈ?",
  "or": "ਜਾਂ"
}
*/

// kn.json
/*
{
  "appName": "ಚಿಟ್ ಫಂಡ್ ಅಪ್ಲಿಕೇಶನ್",
  "welcome": "ಸ್ವಾಗತ",
  "welcomeBack": "ಮರಳಿ ಸ್ವಾಗತ",
  "loginToContinue": "ಮುಂದುವರಿಸಲು ಲಾಗಿನ್ ಮಾಡಿ",
  "email": "ಇಮೇಲ್",
  "enterEmail": "ನಿಮ್ಮ ಇಮೇಲ್ ನಮೂದಿಸಿ",
  "password": "ಪಾಸ್ವರ್ಡ್",
  "enterPassword": "ನಿಮ್ಮ ಪಾಸ್ವರ್ಡ್ ನಮೂದಿಸಿ",
  "login": "ಲಾಗಿನ್",
  "register": "ನೋಂದಣಿ",
  "forgotPassword": "ಪಾಸ್ವರ್ಡ್ ಮರೆತಿರಾ?",
  "noAccount": "ಖಾತೆ ಇಲ್ಲವೇ?",
  "haveAccount": "ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ?",
  "or": "ಅಥವಾ"
}
*/
