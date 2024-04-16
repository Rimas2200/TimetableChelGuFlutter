import 'package:flutter/material.dart';

class ScheduleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
              // Код для первого блока
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green,
              // Код для второго блока
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue,
              // Код для третьего блока
            ),
          ),
        ],
      ),
    );
  }
}