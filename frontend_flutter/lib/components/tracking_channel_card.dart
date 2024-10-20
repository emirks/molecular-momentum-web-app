import 'package:flutter/material.dart';

class TrackingChannelCard extends StatelessWidget {
  final Map<String, dynamic> channelData;

  const TrackingChannelCard({Key? key, required this.channelData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
            Divider(height: 20, thickness: 1),
            _buildSectionTitle('Users and Habits'),
            _buildUserAndHabitList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
    );
  }

  Widget _buildUserAndHabitList() {
    List<dynamic> users = channelData['users'] ?? [];
    List<dynamic> habits = channelData['habits'] ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: users.map((user) {
            List<dynamic> userHabits = habits.where((habit) => habit['user'] == user['id']).toList();
            return Container(
              width: (constraints.maxWidth - 8) / 2,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['username'] ?? 'Unknown User', style: TextStyle(fontWeight: FontWeight.bold)),
                  if (userHabits.isNotEmpty) ...[
                    SizedBox(height: 5),
                    ...userHabits.map((habit) => Padding(
                      padding: EdgeInsets.only(left: 10, top: 2),
                      child: Text(habit['habit_name'] ?? 'Unnamed Habit', style: TextStyle(fontSize: 12)),
                    )).toList(),
                  ],
                ],
              ),
            );
          }).toList(),
        );
      }
    );
  }
}
