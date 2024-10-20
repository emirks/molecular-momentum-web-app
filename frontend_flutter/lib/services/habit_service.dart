import 'dart:convert';
import 'api_service.dart';

class HabitService {
  static Future<List<dynamic>> getUserHabits() async {
    final userId = ApiService.getUserId();
    if (userId == null) {
      throw Exception('User ID not set');
    }
    final response = await ApiService.authenticatedGet('/api/users/$userId/habits/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load habits: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> createHabit(Map<String, dynamic> habitData) async {
    final userId = ApiService.getUserId();
    if (userId == null) {
      throw Exception('User ID not available');
    }
    habitData['user'] = userId;
    // Ensure time_location and identity are included in habitData
    if (!habitData.containsKey('time_location') || !habitData.containsKey('identity')) {
      throw Exception('Habit data must include time_location and identity');
    }
    final response = await ApiService.authenticatedPost('/api/habits/', habitData);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create habit: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getDetailedHabit(String habitId) async {
    final response = await ApiService.authenticatedGet('/api/habits/$habitId/detailed/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detailed habit');
    }
  }

  static Future<void> markHabitCompleted(String habitId) async {
    final response = await ApiService.authenticatedPost('/api/habits/$habitId/mark-completed/', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to mark habit as completed');
    }
  }

  static Future<void> resetHabitStreak(String habitId) async {
    final response = await ApiService.authenticatedPost('/api/streaks/reset/', {'habit_id': habitId});
    if (response.statusCode != 200) {
      throw Exception('Failed to reset habit streak');
    }
  }
}
