class ApiEndpoints {
  static const String baseUrl = 'https://your-api-base-url.com/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  // User endpoints
  static const String getUserProfile = '/user/profile';
  static const String updateProfile = '/user/update-profile';
  static const String uploadProfileImage = '/user/upload-profile-image';
  static const String uploadMultipleImages = '/user/upload-multiple-images';

  // Example endpoints
  static const String getDashboardData = '/dashboard';
  static const String updateSettings = '/settings/update';

  // Helper method to build full URL
  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}
