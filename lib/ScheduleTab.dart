import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru', null);
    selectedDate = DateTime.now();
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: CustomContainer(selectedDate: selectedDate),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 100.0,
              color: Colors.green,
              child: CalendarTab(onDateSelected: onDateSelected),
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


class CalendarTab extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CalendarTab({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late DateTime currentDate;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru', null);
    currentDate = DateTime.now();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 100.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 70,
          itemBuilder: (context, index) {
            DateTime date = currentDate.add(Duration(days: index));
            String formattedDate = DateFormat('d', 'ru').format(date);
            String formattedWeekday = DateFormat('EE', 'ru').format(date);

            bool isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onDateSelected(date); // Вызываем колбэк при выборе даты
                print('Выбрана дата: $formattedDate');
              },
              child: Container(
                width: 50.0,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6226A6) : Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      formattedWeekday.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0x99525252),
                        fontWeight: FontWeight.w300,
                        fontFamily: 'YourFontFamily',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontFamily: 'YourFontFamily',
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
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

class CustomContainer extends StatelessWidget {
  final DateTime selectedDate;

  const CustomContainer({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedWeekday = DateFormat('EEEE', 'ru').format(selectedDate);
    String formattedDate = DateFormat('MMMM yyyy', 'ru').format(selectedDate);

    // Определение четности недели
    String weekType = selectedDate.weekday >= 1 && selectedDate.weekday <= 4 ? '1Н' : '2Н';

    return Expanded(
      flex: 2,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Row(
                  children: [
                    Text(
                      DateFormat('d', 'ru').format(selectedDate),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formattedWeekday[0].toUpperCase() + formattedWeekday.substring(1),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          formattedDate[0].toUpperCase() + formattedDate.substring(1),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekType,
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




