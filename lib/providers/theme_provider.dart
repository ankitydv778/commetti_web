import 'package:flutter/material.dart';
import '../core/services/shared_pref_service.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final SharedPrefService _sharedPref = SharedPrefService();

  ThemeMode get themeMode => _themeMode;

  Future<void> initialize() async {
    await _sharedPref.initialize();
    final savedMode = _sharedPref.getThemeMode();

    switch (savedMode) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'auto':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    String modeString;
    switch (mode) {
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.system:
        modeString = 'auto';
        break;
    }

    await _sharedPref.setThemeMode(modeString);
    notifyListeners();
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isAutoMode => _themeMode == ThemeMode.system;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  // Get appropriate text color based on theme
  Color get textColor {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Colors.white;
      case ThemeMode.light:
        return Colors.black;
      case ThemeMode.system:
        return Colors.black;
    }
  }

  // Get appropriate background color based on theme
  Color get backgroundColor {
    switch (_themeMode) {
      case ThemeMode.dark:
        return const Color(0xFF121212);
      case ThemeMode.light:
        return Colors.white;
      case ThemeMode.system:
        return Colors.white;
    }
  }

  // Get appropriate card color based on theme
  Color get cardColor {
    switch (_themeMode) {
      case ThemeMode.dark:
        return const Color(0xFF1E1E1E);
      case ThemeMode.light:
        return Colors.white;
      case ThemeMode.system:
        return Colors.white;
    }
  }
}
