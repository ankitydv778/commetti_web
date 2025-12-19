import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();
  factory SharedPrefService() => _instance;
  SharedPrefService._internal();

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth Tokens
  Future<void> setAuthToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  String? getAuthToken() {
    return _prefs.getString('auth_token');
  }

  Future<void> setRefreshToken(String token) async {
    await _prefs.setString('refresh_token', token);
  }

  String? getRefreshToken() {
    return _prefs.getString('refresh_token');
  }

  Future<void> clearAuthTokens() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('refresh_token');
  }

  // User Data
  Future<void> setUserData(String userData) async {
    await _prefs.setString('user_data', userData);
  }

  String? getUserData() {
    return _prefs.getString('user_data');
  }

  Future<void> clearUserData() async {
    await _prefs.remove('user_data');
  }

  // Theme Mode
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString('theme_mode', mode);
  }

  String getThemeMode() {
    return _prefs.getString('theme_mode') ?? 'auto';
  }

  // Language
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString('language', languageCode);
  }

  String getLanguage() {
    return _prefs.getString('language') ?? 'en';
  }

  // First Launch
  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool('first_launch', value);
  }

  bool isFirstLaunch() {
    return _prefs.getBool('first_launch') ?? true;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return getAuthToken() != null;
  }
}
