import 'package:flutter/material.dart';
import 'custom_button.dart';

class HabitDetailScreen extends StatelessWidget {
  final String habitName;
  const HabitDetailScreen({Key? key, required this.habitName}) : super(key: key);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildHabitDetails(),
                const SizedBox(height: 30),
                _buildProgressSection(),
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          habitName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            // Handle edit habit
          },
        ),
      ],
    );
  }

  Widget _buildHabitDetails() {
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
            'Description',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'This is a sample description of the habit.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Frequency',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Daily',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Reminder',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '8:00 AM',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
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
            'Progress',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            '70% Complete',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Streak: 5 days',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Mark as Done',
            onPressed: () {
              // Handle marking habit as done
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CustomButton(
            text: 'Skip',
            onPressed: () {
              // Handle skipping habit
            },
          ),
        ),
      ],
    );
  }
}
