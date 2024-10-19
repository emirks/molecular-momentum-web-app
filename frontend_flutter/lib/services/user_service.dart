import 'dart:convert';
import 'api_service.dart';

class UserService {
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await ApiService.authenticatedPost('/api/users/', userData, requiresToken: false);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  static Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final response = await ApiService.authenticatedGet('/api/users/$userId/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  static Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    try {
      final response = await ApiService.authenticatedGet('/api/users/me/');
      print('getCurrentUserDetails response: ${response.statusCode}, ${response.body}'); // Add this line
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get user details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }
}
