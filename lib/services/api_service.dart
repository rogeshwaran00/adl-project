import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:4000'; // Change to your backend URL

  static Future<T> apiGet<T>(String path, T Function(dynamic) fromJson) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ApiException('GET $path failed', response.statusCode);
    }

    return fromJson(jsonDecode(response.body));
  }

  static Future<List<int>> apiDownload(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path'));

    if (response.statusCode != 200) {
      throw ApiException('DOWNLOAD $path failed', response.statusCode);
    }

    return response.bodyBytes;
  }

  // Dashboard stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    return apiGet('/api/admin/dashboard/stats', (data) => data as Map<String, dynamic>);
  }

  // Dashboard activity
  static Future<List<dynamic>> getDashboardActivity() async {
    return apiGet('/api/admin/dashboard/activity', (data) => data as List<dynamic>);
  }

  // Beneficiaries
  static Future<List<dynamic>> getBeneficiaries() async {
    return apiGet('/api/admin/beneficiaries', (data) => data as List<dynamic>);
  }
}

class ApiException implements Exception {
  final String message;
  final int status;

  ApiException(this.message, this.status);

  @override
  String toString() => 'ApiException: $message (status: $status)';
}
