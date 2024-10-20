import 'package:flutter/material.dart';

class TrackingChannelCard extends StatelessWidget {
  final Map<String, dynamic> channelData;

  const TrackingChannelCard({Key? key, required this.channelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              channelData['name'] ?? 'Channel ${channelData['id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Users:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildUserList(),
            SizedBox(height: 10),
            Text('Habits:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildHabitList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    List<dynamic> users = channelData['users'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: users.map((user) => Text(user['username'] ?? 'Unknown User')).toList(),
    );
  }

  Widget _buildHabitList() {
    List<dynamic> habits = channelData['habits'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: habits.map((habit) => Text(habit['habit_name'] ?? 'Unnamed Habit')).toList(),
    );
  }
}
