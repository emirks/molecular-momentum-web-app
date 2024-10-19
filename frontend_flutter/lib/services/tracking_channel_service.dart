import 'dart:convert';
import 'api_service.dart';

class TrackingChannelService {
  static Future<List<dynamic>> getTrackingChannels() async {
    final response = await ApiService.authenticatedGet('/api/channels/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tracking channels');
    }
  }

  static Future<Map<String, dynamic>> createTrackingChannel(Map<String, dynamic> channelData) async {
    final response = await ApiService.authenticatedPost('/api/channels/', channelData);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create tracking channel');
    }
  }

  static Future<Map<String, dynamic>> getDetailedTrackingChannel(String channelId) async {
    final response = await ApiService.authenticatedGet('/api/channels/$channelId/detailed/');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detailed tracking channel');
    }
  }

  static Future<void> addUserToChannel(String channelId, String userId) async {
    final response = await ApiService.authenticatedPost('/api/channels/$channelId/add-user/', {'user_id': userId});
    if (response.statusCode != 200) {
      throw Exception('Failed to add user to channel');
    }
  }
}
