import 'package:flutter/material.dart';

class FullScheduleScreen extends StatelessWidget {
  final String discipline;
  final String classroom;
  final String teacherName;
  final String pairName;

  FullScheduleScreen({
    required this.discipline,
    required this.classroom,
    required this.teacherName,
    required this.pairName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Полное расписание'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Дисциплина: $discipline',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Аудитория: $classroom',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Преподаватель: $teacherName',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Пара: $pairName',
              style: TextStyle(fontSize: 20),
            ),
            // Добавьте здесь другие элементы интерфейса или логику отображения расписания
          ],
        ),
      ),
    );
  }
}

