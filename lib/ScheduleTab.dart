import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:timetable_chel_gu/FullScheduleScreen.dart';


class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late DateTime selectedDate;
  late String selectedWeekday;
  List<dynamic> scheduleData = [];
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru', null);
    selectedDate = DateTime.now();
    selectedWeekday = DateFormat('EE', 'ru').format(selectedDate);
    fetchScheduleData();
  }
  void onDateSelected(DateTime date, String weekday) {
    setState(() {
      selectedDate = date;
      selectedWeekday = weekday;
    });
    fetchScheduleData();
  }
  Future<void> fetchScheduleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('user_email') ?? '';
    if (userEmail.isNotEmpty) {
      String weekday = convertWeekday(selectedWeekday);
      int weekType = getWeekType(selectedDate);
      // https://umo.csu.ru/
      var url = Uri.parse('https://umo.csu.ru/schedule?user_email=$userEmail&date=$selectedDate&weekday=$weekday&week_type=$weekType');
      logger.i('UserEmail: $userEmail, Date: $selectedDate, Weekday: $weekday, WeekType: $weekType');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          scheduleData = data;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Добро пожаловать!'),
              content: const Text('Следующий шаг: Вам необходимо заполнить поля, чтобы я мог найти для вас подходящее расписание! Вы можете это сделать во вкладке "Настройки"'),
              actions: <Widget>[
                TextButton(
                  child: const Text('ОК'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // print('Ошибка: Почта пользователя не найдена в SharedPreferences');
    }
  }
  String convertWeekday(String shortWeekday) {
    switch (shortWeekday) {
      case 'пн':
        return 'Понедельник';
      case 'вт':
        return 'Вторник';
      case 'ср':
        return 'Среда';
      case 'чт':
        return 'Четверг';
      case 'пт':
        return 'Пятница';
      case 'сб':
        return 'Суббота';
      case 'вс':
        return 'Воскресенье';
      default:
        return shortWeekday;
    }
  }
  int getWeekType(DateTime date) {
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    int firstWeekNumber = firstDayOfYear.weekday > 4 ? 2 : 1;
    int currentWeekNumber = date.difference(firstDayOfYear).inDays ~/ 7 + firstWeekNumber;
    return currentWeekNumber % 2 == 0 ? 1 : 2;
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
          HeaderRow(
            selectedDate: selectedDate,
            selectedWeekday: selectedWeekday,
            scheduleData: scheduleData,
          ),
        ],
      ),
    );
  }
}

class HeaderRow extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedWeekday;
  final List<dynamic> scheduleData;

  HeaderRow({Key? key, required this.selectedDate, required this.selectedWeekday, required this.scheduleData}) : super(key: key);
  @override
  _HeaderRowState createState() => _HeaderRowState();
}

class _HeaderRowState extends State<HeaderRow> {
  SharedPreferences? prefs;
  final Logger logger = Logger();
  late List<dynamic> scheduleData;

  @override
  void initState() {
    super.initState();
    initializePrefs();
    scheduleData = widget.scheduleData;
    _sortScheduleData();
  }

  @override
  void didUpdateWidget(covariant HeaderRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scheduleData != widget.scheduleData) {
      setState(() {
        scheduleData = widget.scheduleData;
        _sortScheduleData();
      });
    }
  }
  Map<String, String> pairTimeMap = {
    '1': '8:00  9:30',
    '2': '9:40  11:10',
    '3': '11:20  12:50',
    '4': '13:15  14:45',
    '5': '15:00  16:30',
    '6': '16:40  18:10',
    '7': '18:20  19:50',
    '8': '19:55  21:25',
  };
  void _sortScheduleData() {
    scheduleData.sort((a, b) {
      int pairA = int.parse(a['pair_name']);
      int pairB = int.parse(b['pair_name']);
      return pairA.compareTo(pairB);
    });
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return const SizedBox();
    }
    return Expanded(
      flex: 9,
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0),
                    child: Text(
                      'Время',
                      style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: scheduleData.length,
                    itemBuilder: (context, index) {
                      var entry = scheduleData[index];
                      String? pairTime = pairTimeMap[entry['pair_name']];
                      return Container(
                        height: 140,
                        margin: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: pairTime?.split(' ')[0] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),
                                  ),
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: pairTime?.split(' ')[2] ?? '',
                                    style: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0),
                    child: Text(
                      'Расписание',
                      style: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: scheduleData.length,
                    itemBuilder: (context, index) {
                      var entry = scheduleData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScheduleScreen(
                                discipline: entry['discipline'],
                                classroom: entry['classroom'],
                                teacherName: entry['teacher_name'],
                                pairName: entry['pair_name'],
                              ),
                            ),
                          );
                        },
                    child: Container(
                      height: 140,
                      margin: const EdgeInsets.only(bottom: 16.0, left: 0.0, right: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xFF6226A6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry['discipline']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                              side: WidgetStateProperty.all(BorderSide.none),
                            ),
                            icon: const Icon(Icons.location_on_sharp, size: 28, color: Colors.white),
                            label: Text(
                              'Аудитория: ${entry['classroom']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            style: ButtonStyle(
                              side: WidgetStateProperty.all(BorderSide.none),
                            ),
                            icon: const Icon(Icons.school, size: 26, color: Colors.white),
                            label: Text(
                              '${entry['teacher_name']}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
           ),
          ),
         ],
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class FullScheduleScreen extends StatelessWidget {
  final String discipline;
  final String classroom;
  final String teacherName;
  final String pairName;
  Map<String, String> pairTimeMap = {
    '1': 'С 8:00 по 9:30',
    '2': 'С 9:40 по 11:10',
    '3': 'С 11:20 по 12:50',
    '4': 'С 13:15 по 14:45',
    '5': 'С 15:00 по 16:30',
    '6': 'С 16:40 по 18:10',
    '7': 'С 18:20 по 19:50',
    '8': 'С 19:55 по 21:25',
  };
  FullScheduleScreen({super.key,
    required this.discipline,
    required this.classroom,
    required this.teacherName,
    required this.pairName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    discipline,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.deepPurple, size: 28),
                    const SizedBox(width: 8.0),
                    Text(
                      'Аудитория: $classroom',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.school, color: Colors.deepPurple, size: 28),
                    const SizedBox(width: 8.0),
                    Text(
                      'Преподаватель: $teacherName',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.deepPurple, size: 28),
                    const SizedBox(width: 8.0),
                    Text(
                      'Время: ${pairTimeMap[pairName]}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }
}

class CalendarTab extends StatefulWidget {
  final Function(DateTime date, String weekday) onDateSelected;

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
                widget.onDateSelected(date, formattedWeekday);
                // print('Выбрана дата: $formattedDate');
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
                        // fontFamily: 'YourFontFamily',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        // fontFamily: 'YourFontFamily',
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

    int weekNumber = ((selectedDate.difference(DateTime(selectedDate.year, 1, 1)).inDays) ~/ 7) % 2 == 0 ? 1 : 2;
    String weekType = weekNumber == 2 ? '1Н' : '2Н';

    return LayoutBuilder(
      builder: (context, constraints) {
        double paddingValue = constraints.maxWidth * 0.08;
        double fontSizeDate = constraints.maxWidth * 0.17;
        double fontSizeWeekType = constraints.maxWidth * 0.17;
        double fontSizeWeekday = constraints.maxWidth * 0.065;
        double fontSizeMonthYear = constraints.maxWidth * 0.035;

        return Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                child: Padding(
                  padding: EdgeInsets.all(paddingValue),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('d', 'ru').format(selectedDate),
                        style: TextStyle(
                          fontSize: fontSizeDate,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedWeekday[0].toUpperCase() + formattedWeekday.substring(1),
                            style: TextStyle(
                              fontSize: fontSizeWeekday,
                              color: Colors.black38,
                            ),
                          ),
                          Text(
                            formattedDate[0].toUpperCase() + formattedDate.substring(1),
                            style: TextStyle(
                              fontSize: fontSizeMonthYear,
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
                  padding: EdgeInsets.all(paddingValue),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekType,
                        style: TextStyle(
                          fontSize: fontSizeWeekType,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
// Future<void> fetchUserGroupData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String userEmail = prefs.getString('user_email') ?? '';
//   if (userEmail.isEmpty) {
//     print('Ошибка: Почта пользователя не найдена в SharedPreferences');
//     return;
//   }
//   var url = Uri.parse('http://localhost:3000/userstest?user_email=$userEmail');
//   var response = await http.get(url);
//   if (response.statusCode == 200) {
//     var data = jsonDecode(response.body);
//     print('Группа: ${data['group_name']}, Подгруппа: ${data['subgroup']}');
//   } else {
//     // Если произошла ошибка при выполнении запроса
//     print('Ошибка при получении данных: ${response.statusCode}');
//   }
// }



