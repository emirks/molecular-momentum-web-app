import 'package:flutter/material.dart';
import 'habit_detail_screen.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade300, Colors.orange.shade300],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildGreeting(),
                const SizedBox(height: 20),
                _buildActionButtons(context),
                const SizedBox(height: 20),
                _buildRoutine(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              'Friday, Oct 8',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RISE AND SHINE, BELLA!',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'HOW ARE YOU FEELING TODAY?',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_forward, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddHabitScreen()),
              );
            },
            icon: Icon(Icons.add),
            label: Text('Add New Habit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Work Mode functionality remains unchanged
            },
            icon: Icon(Icons.work),
            label: Text('Work Mode'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutine(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Routine',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.more_horiz),
            ],
          ),
          SizedBox(height: 10),
          Text('5 Tasks | Morning', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 15),
          _buildTaskItem(context, 'Drink 1 glass of water'),
          SizedBox(height: 10),
          _buildTaskItem(context, 'Meditate for 10 mins'),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, String task) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HabitDetailScreen(habitName: task)),
        );
      },
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(child: Text(task)),
          ElevatedButton(
            onPressed: () {
              // Mark as done functionality remains unchanged
            },
            child: Text('Mark as done'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 12),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ],
      ),
    );
  }
}
