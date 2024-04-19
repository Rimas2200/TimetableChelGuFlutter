import 'package:flutter/material.dart';
// import 'package:timetable_chel_gu/RegistrationPage.dart';
// import 'package:timetable_chel_gu/signup.dart';
import 'package:timetable_chel_gu/loginPage.dart';
// import 'package:timetable_chel_gu/ScheduleTab.dart';
import 'package:timetable_chel_gu/CustomTabBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),

      routes: {
        '/registration': (context) => LoginPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Registration'),
          onPressed: () {
            Navigator.pushNamed(context, '/registration');
          },
        ),
      ),
    );
  }
}