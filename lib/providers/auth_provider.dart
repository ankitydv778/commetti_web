import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/api_service.dart';
import '../core/services/shared_pref_service.dart';
import '../core/utils/alert_bar.dart';
import '../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SharedPrefService _sharedPref = SharedPrefService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  UserModel? _user;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;

  // Initialize provider
  Future<void> initialize() async {
    await _sharedPref.initialize();
    _isLoggedIn = _sharedPref.isLoggedIn();

    if (_isLoggedIn) {
      String? userData = _sharedPref.getUserData();
      if (userData != null) {
        try {
          _user = UserModel.fromJson(json.decode(userData));
        } catch (e) {
          _user = null;
        }
      }
    }
    notifyListeners();
  }

  // Login method
  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response['success'] == true) {
        // Save tokens
        await _sharedPref.setAuthToken(response['data']['token']);
        await _sharedPref.setRefreshToken(response['data']['refresh_token']);

        // Save user data
        _user = UserModel.fromJson(response['data']['user']);
        await _sharedPref.setUserData(json.encode(_user!.toJson()));

        _isLoggedIn = true;

        // Show success message
        AlertBar.showSuccess(context: context, message: 'Login successful!');

        return true;
      } else {
        AlertBar.showError(context: context, message: response['message']);
        return false;
      }
    } catch (e) {
      AlertBar.showError(
        context: context,
        message: 'Login failed. Please try again.',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register method
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required String address,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'gender': gender,
          'address': address,
        },
      );

      if (response['success'] == true) {
        AlertBar.showSuccess(
          context: context,
          message: 'Registration successful! Please login.',
        );
        return true;
      } else {
        AlertBar.showError(context: context, message: response['message']);
        return false;
      }
    } catch (e) {
      AlertBar.showError(
        context: context,
        message: 'Registration failed. Please try again.',
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Even if API call fails, clear local data
    } finally {
      await _sharedPref.clearAuthTokens();
      await _sharedPref.clearUserData();
      _isLoggedIn = false;
      _user = null;
      _isLoading = false;
      notifyListeners();

      AlertBar.showSuccess(
        context: context,
        message: 'Logged out successfully!',
      );
    }
  }

  // Check authentication status
  Future<bool> checkAuth() async {
    if (!_isLoggedIn) return false;

    try {
      final response = await _apiService.get('/auth/check');
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
