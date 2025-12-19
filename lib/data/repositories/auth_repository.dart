import 'dart:convert';

import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/services/shared_pref_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final SharedPrefService _sharedPref = SharedPrefService();

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
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
        final user = UserModel.fromJson(response['data']['user']);
        await _sharedPref.setUserData(json.encode(user.toJson()));

        return {
          'success': true,
          'data': response['data'],
          'message': response['message'],
        };
      } else {
        return {
          'success': false,
          'message': response['message'],
          'errors': response['errors'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Login failed. Please try again.'};
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required String address,
  }) async {
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

      return {
        'success': response['success'] == true,
        'data': response['data'],
        'message': response['message'],
        'errors': response['errors'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration failed. Please try again.',
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiService.post('/auth/logout');

      // Clear local storage regardless of API response
      await _sharedPref.clearAuthTokens();
      await _sharedPref.clearUserData();

      return {
        'success': response['success'] == true,
        'message': response['message'],
      };
    } catch (e) {
      // Even if API fails, clear local storage
      await _sharedPref.clearAuthTokens();
      await _sharedPref.clearUserData();

      return {'success': true, 'message': 'Logged out successfully'};
    }
  }

  // Check authentication status
  Future<bool> checkAuth() async {
    final token = _sharedPref.getAuthToken();
    if (token == null) return false;

    try {
      final response = await _apiService.get('/auth/check');
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final userData = _sharedPref.getUserData();
    if (userData != null) {
      try {
        return UserModel.fromJson(json.decode(userData));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh-token');
      if (response['success'] == true) {
        await _sharedPref.setAuthToken(response['data']['token']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return {
        'success': response['success'] == true,
        'message': response['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Failed to process request.'};
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/reset-password',
        data: {'token': token, 'password': newPassword},
      );

      return {
        'success': response['success'] == true,
        'message': response['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Failed to reset password.'};
    }
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String gender,
    required String address,
  }) async {
    try {
      final response = await _apiService.put(
        '/user/update-profile',
        data: {
          'name': name,
          'phone': phone,
          'gender': gender,
          'address': address,
        },
      );

      if (response['success'] == true) {
        final user = UserModel.fromJson(response['data']);
        await _sharedPref.setUserData(json.encode(user.toJson()));
      }

      return {
        'success': response['success'] == true,
        'data': response['data'],
        'message': response['message'],
      };
    } catch (e) {
      return {'success': false, 'message': 'Failed to update profile.'};
    }
  }
}
