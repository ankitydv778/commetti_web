import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import '../utils/alert_bar.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    BaseOptions options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token if exists
          String? token = _prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            bool refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              return handler.resolve(await _retry(error.requestOptions));
            } else {
              // Logout user
              await _logoutUser();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      String? refreshToken = _prefs.getString('refresh_token');
      if (refreshToken == null) return false;

      var response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        String newToken = response.data['data']['token'];
        await _prefs.setString('auth_token', newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _logoutUser() async {
    await _prefs.clear();
    // Navigate to login screen (handled in main app)
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  // GET Request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // POST Request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // PUT Request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      Response response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // DELETE Request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      Response response = await _dio.delete(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // Upload Single Image
  Future<Map<String, dynamic>> uploadSingleImage(
    String endpoint,
    File imageFile, {
    String fieldName = 'image',
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        ...?additionalData,
      });

      Response response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // Upload Multiple Images
  Future<Map<String, dynamic>> uploadMultipleImages(
    String endpoint,
    List<File> imageFiles, {
    String fieldName = 'images',
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      List<MultipartFile> multipartFiles = [];

      for (var i = 0; i < imageFiles.length; i++) {
        String fileName = imageFiles[i].path.split('/').last;
        multipartFiles.add(
          await MultipartFile.fromFile(imageFiles[i].path, filename: fileName),
        );
      }

      FormData formData = FormData.fromMap({
        fieldName: multipartFiles,
        ...?additionalData,
      });

      Response response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGenericError(e);
    }
  }

  // Handle Response
  Map<String, dynamic> _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return {
          'success': true,
          'data': response.data,
          'message': response.data['message'] ?? 'Success',
          'statusCode': response.statusCode,
        };
      case 400:
        return {
          'success': false,
          'message': response.data['message'] ?? 'Bad Request',
          'statusCode': response.statusCode,
          'data': response.data,
        };
      case 401:
        return {
          'success': false,
          'message': 'Unauthorized. Please login again.',
          'statusCode': response.statusCode,
        };
      case 403:
        return {
          'success': false,
          'message': 'Forbidden. You don\'t have permission.',
          'statusCode': response.statusCode,
        };
      case 404:
        return {
          'success': false,
          'message': 'Resource not found.',
          'statusCode': response.statusCode,
        };
      case 422:
        return {
          'success': false,
          'message': 'Validation failed.',
          'errors': response.data['errors'],
          'statusCode': response.statusCode,
        };
      case 500:
        return {
          'success': false,
          'message': 'Internal server error. Please try again later.',
          'statusCode': response.statusCode,
        };
      default:
        return {
          'success': false,
          'message': 'Something went wrong!',
          'statusCode': response.statusCode,
        };
    }
  }

  // Handle Dio Error
  Map<String, dynamic> _handleDioError(DioException e) {
    String message = 'Something went wrong!';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection. Please check your network.';
    } else if (e.type == DioExceptionType.badResponse) {
      if (e.response != null) {
        return _handleResponse(e.response!);
      }
    } else if (e.type == DioExceptionType.cancel) {
      message = 'Request cancelled.';
    }

    return {
      'success': false,
      'message': message,
      'statusCode': e.response?.statusCode ?? 500,
    };
  }

  // Handle Generic Error
  Map<String, dynamic> _handleGenericError(dynamic e) {
    return {'success': false, 'message': e.toString(), 'statusCode': 500};
  }

  // Cancel ongoing requests
  void cancelRequests([CancelToken? token]) {
    token?.cancel('Cancelled by user');
  }
}
