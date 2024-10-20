import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://46.101.165.181:8000';
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

  static void clearUserId() {
    _userId = null;
  }

  static void clearToken() {
    _token = null;
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
    
    print('Sending POST request to: $baseUrl$endpoint');
    print('Request headers: $headers');
    print('Request body: ${json.encode(data)}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    return response;
  }

  static Future<http.Response> authenticatedPut(String endpoint, dynamic data) async {
    final token = getToken();
    if (token == null) {
      throw Exception('No token available');
    }
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    
    print('Sending PUT request to: $baseUrl$endpoint');
    print('Request headers: ${response.request?.headers}');
    print('Request body: ${json.encode(data)}');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    return response;
  }
}
