import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:4000/api';

  static Future<ApiResult<List<dynamic>>> fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return ApiResult.success(jsonDecode(response.body));
      }
      return ApiResult.error('Failed to load services (${response.statusCode})');
    } catch (e) {
      return ApiResult.error('Connection error: ${e.toString()}');
    }
  }

  static Future<ApiResult<Map<String, dynamic>>> fetchSubOptions(
    String serviceId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/$serviceId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return ApiResult.success(jsonDecode(response.body));
      }
      return ApiResult.error('Failed to load options');
    } catch (e) {
      return ApiResult.error('Connection error: ${e.toString()}');
    }
  }

  static Future<ApiResult<List<dynamic>>> fetchServiceDetails(
    String serviceId,
    String subOptionId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/servicedetails/service/$serviceId/suboption/$subOptionId',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return ApiResult.success(jsonDecode(response.body));
      }
      return ApiResult.error('Failed to load details');
    } catch (e) {
      return ApiResult.error('Connection error: ${e.toString()}');
    }
  }
}

class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResult._({this.data, this.errorMessage, required this.isSuccess});

  factory ApiResult.success(T data) =>
      ApiResult._(data: data, isSuccess: true);

  factory ApiResult.error(String message) =>
      ApiResult._(errorMessage: message, isSuccess: false);
}
