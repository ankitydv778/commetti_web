import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../core/services/api_service.dart';
import '../core/services/image_picker_service.dart';
import '../core/services/shared_pref_service.dart';
import '../core/utils/alert_bar.dart';
import '../core/utils/watermark_helper.dart';
import '../data/models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SharedPrefService _sharedPref = SharedPrefService();
  final ImagePickerService _imagePicker = ImagePickerService();

  bool _isLoading = false;
  bool _isUpdating = false;
  UserModel? _user;
  File? _selectedImage;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  UserModel? get user => _user;
  File? get selectedImage => _selectedImage;

  // Initialize provider
  Future<void> initialize() async {
    await _sharedPref.initialize();
    _loadUserData();
  }

  // Load user data
  Future<void> _loadUserData() async {
    String? userData = _sharedPref.getUserData();
    if (userData != null) {
      try {
        _user = UserModel.fromJson(json.decode(userData));
      } catch (e) {
        _user = null;
      }
      notifyListeners();
    }
  }

  // Fetch user profile from API
  Future<void> fetchProfile(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/user/profile');

      if (response['success'] == true) {
        _user = UserModel.fromJson(response['data']);
        await _sharedPref.setUserData(json.encode(_user!.toJson()));

        AlertBar.showSuccess(
          context: context,
          message: 'Profile updated successfully!',
        );
      } else {
        AlertBar.showError(context: context, message: response['message']);
      }
    } catch (e) {
      AlertBar.showError(context: context, message: 'Failed to fetch profile.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pick profile image
  Future<void> pickProfileImage(BuildContext context) async {
    try {
      File? image = await _imagePicker.pickImage(
        context: context,
        source: ImageSource.gallery,
      );

      if (image != null) {
        // Add watermark to image
        File watermarkedImage = await WatermarkHelper.addWatermark(
          image,
          text: 'Chit Fund App',
          position: WatermarkPosition.bottomRight,
        );

        _selectedImage = watermarkedImage;
        notifyListeners();

        // Auto upload after selection
        await uploadProfileImage(context);
      }
    } catch (e) {
      AlertBar.showError(context: context, message: 'Failed to pick image.');
    }
  }

  // Upload profile image
  Future<void> uploadProfileImage(BuildContext context) async {
    if (_selectedImage == null) return;

    _isUpdating = true;
    notifyListeners();

    try {
      final response = await _apiService.uploadSingleImage(
        '/user/upload-profile-image',
        _selectedImage!,
      );

      if (response['success'] == true) {
        _user = _user?.copyWith(profileImage: response['data']['image_url']);

        if (_user != null) {
          await _sharedPref.setUserData(json.encode(_user!.toJson()));
        }

        AlertBar.showSuccess(
          context: context,
          message: 'Profile image updated successfully!',
        );
      } else {
        AlertBar.showError(context: context, message: response['message']);
      }
    } catch (e) {
      AlertBar.showError(context: context, message: 'Failed to upload image.');
    } finally {
      _isUpdating = false;
      _selectedImage = null;
      notifyListeners();
    }
  }

  // Update profile details
  Future<void> updateProfile({
    required BuildContext context,
    required String name,
    required String phone,
    required String gender,
    required String address,
  }) async {
    _isUpdating = true;
    notifyListeners();

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
        _user = UserModel.fromJson(response['data']);
        await _sharedPref.setUserData(json.encode(_user!.toJson()));

        AlertBar.showSuccess(
          context: context,
          message: 'Profile updated successfully!',
        );
      } else {
        AlertBar.showError(context: context, message: response['message']);
      }
    } catch (e) {
      AlertBar.showError(
        context: context,
        message: 'Failed to update profile.',
      );
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Clear selected image
  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }
}
