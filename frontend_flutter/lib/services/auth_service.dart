import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';

class AuthService {
  static Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/token/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ApiService.setToken(data['access']);
        print('Token set after login: ${ApiService.getToken()}'); // Add this line
        return true;
      } else {
        print('Login failed. Status code: ${response.statusCode}, Body: ${response.body}'); // Add this line
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      ApiService.clearToken();
      ApiService.clearUserId();
      print('Logout successful: Token and UserId cleared');
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
