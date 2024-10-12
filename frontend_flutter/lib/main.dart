import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/add_habit': (context) => const AddHabitScreen(),
        // Remove the '/habit_detail' route as it now requires a dynamic habitId
      },
    );
  }
}
