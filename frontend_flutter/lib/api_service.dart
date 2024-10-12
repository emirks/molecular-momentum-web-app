import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Use your actual backend URL
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

  static Future<http.Response> authenticatedGet(String endpoint) async {
    final token = getToken();
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

  static Future<http.Response> authenticatedPost(String endpoint, dynamic data) async {
    final token = getToken();
    if (token == null) {
      throw Exception('No token available');
    }
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  static Future<List<dynamic>> getUserHabits() async {
    final userId = getUserId();
    print('User ID: $userId'); // Debug print
    if (userId == null) {
      throw Exception('User ID not set');
    }
    final response = await authenticatedGet('/api/users/$userId/habits/');
    print('Response status: ${response.statusCode}'); // Debug print
    print('Response body: ${response.body}'); // Debug print
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load habits: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> createHabit(Map<String, dynamic> habitData) async {
    final response = await authenticatedPost('/api/habits/', habitData);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create habit');
    }
  }

  static Future<Map<String, dynamic>> getDetailedHabit(String habitId) async {
    final response = await authenticatedGet('/api/habits/$habitId/detailed/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detailed habit');
    }
  }

  static Future<void> markHabitCompleted(String habitId) async {
    final response = await authenticatedPost('/api/habits/$habitId/mark-completed/', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to mark habit as completed');
    }
  }

  static Future<List<dynamic>> getTrackingChannels() async {
    final response = await authenticatedGet('/api/channels/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tracking channels');
    }
  }

  static Future<Map<String, dynamic>> createTrackingChannel(Map<String, dynamic> channelData) async {
    final response = await authenticatedPost('/api/channels/', channelData);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create tracking channel');
    }
  }

  static Future<Map<String, dynamic>> getDetailedTrackingChannel(String channelId) async {
    final response = await authenticatedGet('/api/channels/$channelId/detailed/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detailed tracking channel');
    }
  }

  static Future<void> addUserToChannel(String channelId, String userId) async {
    final response = await authenticatedPost('/api/channels/$channelId/add-user/', {'user_id': userId});
    if (response.statusCode != 200) {
      throw Exception('Failed to add user to channel');
    }
  }

  static Future<void> resetHabitStreak(String habitId) async {
    final response = await authenticatedPost('/api/streaks/reset/', {'habit_id': habitId});
    if (response.statusCode != 200) {
      throw Exception('Failed to reset habit streak');
    }
  }

  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }
}
