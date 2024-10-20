import 'package:flutter/material.dart';

class DesignRenderScreen extends StatefulWidget {
  @override
  _DesignRenderScreenState createState() => _DesignRenderScreenState();
}

class _DesignRenderScreenState extends State<DesignRenderScreen> {
  String selectedDay = 'All days';
  List<Map<String, dynamic>> habits = [
    {'title': 'I will take 3 deep breathe', 'subtitle': 'After I, brush my teeth', 'color': Colors.orange[100]!, 'icon': '😊'},
    {'title': 'I will read an article', 'subtitle': 'After having my dinner', 'color': Colors.blue[100]!, 'icon': '😊'},
    {'title': 'I will take a head shower', 'subtitle': 'After I, brush my teeth', 'color': Colors.pink[100]!, 'icon': '😊'},
    {'title': 'I will go for a cycling', 'subtitle': 'After I, get up in the morning', 'color': Colors.teal[100]!, 'icon': '😊'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All habits'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.bar_chart, color: Colors.black),
            label: Text('My stats', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) => _buildHabitCard(habits[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildDaySelector() {
    List<String> days = ['All days', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(days[index]),
              selected: selectedDay == days[index],
              onSelected: (selected) {
                setState(() {
                  selectedDay = days[index];
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit) {
    return Card(
      color: habit['color'],
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  habit['icon'],
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 8),
                Text(
                  habit['title'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              habit['subtitle'],
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(Icons.home), onPressed: () {}),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {}),
        ],
      ),
    );
  }
}
