import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:4000/api';

  static Future<List<dynamic>> fetchServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/services'),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> fetchSubOptions(
      String serviceId,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/$serviceId'),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> fetchServiceDetails(
      String serviceId,
      String subOptionId,
      ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/servicedetails/service/$serviceId/suboption/$subOptionId',
      ),
    );

    return jsonDecode(response.body);
  }
}