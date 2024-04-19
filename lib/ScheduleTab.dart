import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.red,
              // Код для первого блока
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 100.0,
              color: Colors.green,
              child: const CalendarTab(),
            ),
          ),
          Expanded(
            flex: 7,
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

class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru', null);

    return Container(
      color: Colors.green,
      child: SizedBox(
        height: 100.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 70,
          itemBuilder: (context, index) {
            DateTime date = DateTime.now().add(Duration(days: index));
            String formattedDate = DateFormat('d', 'ru').format(date);
            String formattedWeekday = DateFormat('E', 'ru').format(date);

            bool isCurrentDay = date.day == DateTime.now().day;

            return GestureDetector(
              onTap: () {
                // Обработчик нажатия на дату
                print('Выбрана дата: $formattedDate');
              },
              child: Container(
                width: 50.0,
                color: isCurrentDay ? const Color(0xFF6226A6) : Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      formattedWeekday.toUpperCase(),
                      style: TextStyle(
                        color: isCurrentDay ? Colors.white : const Color(0xC7525252),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'YourFontFamily',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontFamily: 'YourFontFamily',
                        fontWeight: FontWeight.bold,
                        color: isCurrentDay ? Colors.white : const Color(0xC7525252),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}