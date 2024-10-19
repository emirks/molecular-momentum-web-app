import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  static String? _token;
  static String? _userId;

  static void setToken(String token) {
    _token = token;
  }

  static String? getToken() {
    return _token;
  }

  static void setUserId(String userId) {
    _userId = userId;
  }

  static String? getUserId() {
    return _userId;
  }

  static bool isUserIdSet() {
    return _userId != null;
  }

  static Future<http.Response> authenticatedGet(String endpoint) async {
    final token = getToken();
    print('Token for request: $token'); // Add this line
    if (token == null) {
      throw Exception('No token available');
    }
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> authenticatedPost(String endpoint, dynamic data, {bool requiresToken = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (requiresToken) {
      final token = getToken();
      if (token == null) {
        throw Exception('No token available');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    
    return response;
  }
}
