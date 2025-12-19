import 'package:flutter/material.dart';
import '../core/services/localization_service.dart';
import '../core/services/shared_pref_service.dart';

class LanguageProvider with ChangeNotifier {
  final LocalizationService _localizationService = LocalizationService();
  final SharedPrefService _sharedPref = SharedPrefService();

  Locale _currentLocale = const Locale('en', 'US');
  bool _isLoading = false;

  Locale get currentLocale => _currentLocale;
  bool get isLoading => _isLoading;
  Map<String, String> get supportedLanguages =>
      _localizationService.supportedLanguages;

  Future<void> initialize() async {
    await _sharedPref.initialize();
    await _localizationService.initialize();

    final savedLanguage = _sharedPref.getLanguage();
    _currentLocale = Locale(savedLanguage);

    // Load the saved language
    await changeLanguage(savedLanguage);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!_localizationService.supportedLanguages.containsKey(languageCode)) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _localizationService.changeLanguage(languageCode);
      await _sharedPref.setLanguage(languageCode);
      _currentLocale = Locale(languageCode);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String translate(String key) {
    return _localizationService.translate(key);
  }

  bool isCurrentLanguage(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }

  // Get language name from code
  String getLanguageName(String code) {
    return _localizationService.supportedLanguages[code] ?? code;
  }

  // Get current language name
  String get currentLanguageName {
    return getLanguageName(_currentLocale.languageCode);
  }

  // Get flag emoji for language
  String getFlagEmoji(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'hi':
        return '🇮🇳';
      case 'pa':
        return '🇮🇳';
      case 'kn':
        return '🇮🇳';
      default:
        return '🌐';
    }
  }

  // Get current flag emoji
  String get currentFlagEmoji {
    return getFlagEmoji(_currentLocale.languageCode);
  }
}
