import 'package:flutter/material.dart';
import 'accounts_page.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade300, Colors.orange.shade300],
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.white),
              title: Text('Account', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.white),
              title: Text('Notifications', style: TextStyle(color: Colors.white)),
              onTap: () {
                // TODO: Implement notification settings
              },
            ),
            ListTile(
              leading: Icon(Icons.color_lens, color: Colors.white),
              title: Text('Theme', style: TextStyle(color: Colors.white)),
              onTap: () {
                // TODO: Implement theme settings
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text('Help & Support', style: TextStyle(color: Colors.white)),
              onTap: () {
                // TODO: Implement help & support
              },
            ),
          ],
        ),
      ),
    );
  }
}
