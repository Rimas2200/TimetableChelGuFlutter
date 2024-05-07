import 'package:flutter/material.dart';
// import 'package:timetable_chel_gu/RegistrationPage.dart';
// import 'package:timetable_chel_gu/signup.dart';
import 'package:timetable_chel_gu/loginPage.dart';
// import 'package:timetable_chel_gu/ScheduleTab.dart';
import 'package:timetable_chel_gu/CustomTabBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(prefs: prefs),
      routes: {
        '/registration': (context) => LoginPage(prefs: prefs),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final SharedPreferences prefs;

  const MyHomePage({Key? key, required this.prefs}) : super(key: key);

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
