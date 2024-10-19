import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'services/habit_service.dart';

class HabitDetailScreen extends StatefulWidget {
  final String habitId;
  const HabitDetailScreen({Key? key, required this.habitId}) : super(key: key);

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  Map<String, dynamic>? _habitDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHabitDetails();
  }

  Future<void> _fetchHabitDetails() async {
    try {
      final habitDetails = await HabitService.getDetailedHabit(widget.habitId);
      setState(() {
        _habitDetails = habitDetails;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching habit details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
          _habitDetails?['habit_name'] ?? '',
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
            'Time & Location',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _habitDetails?['time_location'] ?? '',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Identity',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _habitDetails?['identity'] ?? '',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final streak = _habitDetails?['streak'] ?? {};
    final currentStreak = streak['current_streak'] ?? 0;
    final longestStreak = streak['longest_streak'] ?? 0;

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
          Text(
            'Current Streak: $currentStreak days',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            'Longest Streak: $longestStreak days',
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
            onPressed: () async {
              try {
                await HabitService.markHabitCompleted(widget.habitId);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Habit marked as completed!')));
                _fetchHabitDetails();
              } catch (e) {
                print('Error marking habit as completed: $e');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to mark habit as completed')));
              }
            },
          ),
        ),
      ],
    );
  }
}
