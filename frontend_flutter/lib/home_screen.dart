import 'package:flutter/material.dart';
import 'habit_detail_screen.dart';
import 'add_habit_screen.dart';
import 'services/api_service.dart';
import 'services/habit_service.dart';
import 'services/user_service.dart';
import 'settings_screen.dart';
import 'services/auth_service.dart';
import 'tracking_channels_screen.dart';
import 'design_render_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _habits = [];
  bool _isLoading = true;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (ApiService.isUserIdSet()) {
      await _fetchUserData();
      await _fetchHabits();
    } else {
      // If user ID is not set, navigate back to login screen
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final userData = await UserService.getCurrentUserDetails();
      if (userData != null) {
        setState(() {
          _username = userData['username'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchHabits() async {
    try {
      final habits = await HabitService.getUserHabits();
      setState(() {
        _habits = List<Map<String, dynamic>>.from(habits);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching habits: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markHabitAsCompleted(String habitId) async {
    try {
      await HabitService.markHabitCompleted(habitId);
      await _fetchHabits(); // Refresh the habits list
    } catch (e) {
      print('Error marking habit as completed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildSidebar(),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
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
                    _buildHeader(context),
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
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Today',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rise and Shine, ' + _username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'How are you today?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddHabitScreen()),
            ).then((_) => _fetchHabits());
          },
          icon: Icon(Icons.add, color: Colors.pink.shade300),
          label: Text('Add New Habit', style: TextStyle(color: Colors.pink.shade300)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutine(BuildContext context) {
    return Expanded(
      child: Container(
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
                  'Your Habits',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.more_horiz),
              ],
            ),
            SizedBox(height: 10),
            Text('${_habits.length} Habits', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 15),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _habits.length,
                      itemBuilder: (context, index) {
                        final habit = _habits[index];
                        return _buildTaskItem(context, habit);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> habit) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HabitDetailScreen(habitId: habit['id'].toString())),
        ).then((_) => _fetchHabits());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(child: Text(habit['habit_name'])),
            ElevatedButton(
              onPressed: () => _markHabitAsCompleted(habit['id'].toString()),
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
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink.shade300,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Tracking Channels'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackingChannelsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await AuthService.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Design Render'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DesignRenderScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
