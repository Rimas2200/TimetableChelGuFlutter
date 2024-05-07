import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String truncateDepartmentName(String name, int maxLength) {
    if (name.length > maxLength) {
      return '${name.substring(0, maxLength)}...';
    }
    return name;
  }
  final Logger logger = Logger();
  List<String> _departments = [];
  List<String> _faculties = [];
  List<String> _selectedDirection = [];
  List<String> _professors = [];
  final List<String> _selectedGroups = [];
  String _selectedRole = 'Студент';
  String? _selectedFaculty;
  String? _selectedSubgroup;
  String? _selectedTeacher;
  String? _selectedDepartment;
  String? _selectedGroup;
  List<String> _directions = [];
  List<String> _groups = [];
  final List<String> _subgroups = ['Подгруппа 1', 'Подгруппа 2', 'Подгруппа 3'];
  List<String> _filteredTeachers = [];
  void filterTeachers(String query) {
    setState(() {
      if (_filteredTeachers.isEmpty) {
        _filteredTeachers = _professors.where((teacher) => teacher.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
  @override
  void initState() {
    super.initState();
    fetchFaculties().then((faculties) {
      setState(() {
        _faculties = faculties;
      });
    }).catchError((error) {
      logger.e('Error fetching faculties: $error');
    });
    if (_selectedDepartment != null) {
      fetchProfessors(_selectedDepartment!).catchError((error) {
        logger.e('Error fetching professors: $error');
      });
    }
    fetchDepartments().then((departments) {
      setState(() {
        _departments = departments;
      });
    }).catchError((error) {
      logger.e('Error fetching departments: $error');
    });
    fetchFaculties().then((faculties) {
      setState(() {
        _faculties = faculties;
      });
    }).catchError((error) {
      logger.e('Error fetching faculties: $error');
    });
    if (_selectedDepartment != null) {
      fetchProfessors(_selectedDepartment!).catchError((error) {
        logger.e('Error fetching professors: $error');
      });
    } else {
    }
    fetchDepartments().then((departments) {
      setState(() {
        _departments = departments;
      });
    }).catchError((error) {
      logger.e('Error fetching departments: $error');
    });
  }
  Future<void> sendDataToServers(String faculty, String direction, String groupName, String subGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('user_email') ?? ''; // Присваиваем пустую строку, если userEmail равен null
    if (userEmail == null) {
      logger.e('Ошибка: Почта пользователя не найдена в SharedPreferences');
      return;
    }
    var url = Uri.parse('http://localhost:3000/users/profile_two');
    logger.i('user_email: $userEmail, faculty: $faculty, direction: $direction, group_name: $groupName, subgroup: $subGroup');
    var body = jsonEncode({
      'user_email': userEmail,
      'faculty': faculty,
      'direction': direction,
      'group_name': groupName,
      'subgroup': subGroup,
    });
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, // Укажем заголовок для сообщения о типе содержимого
      body: body,
    );
    if (response.statusCode == 200) {
      logger.e('Данные успешно отправлены');
    } else {
      logger.e('Ошибка отправки данных: ${response.statusCode}');
    }
  }
  Future<void> sendDataToServer(String department, String teacher) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('user_email') ?? '';
    if (userEmail == null) {
      logger.e('Ошибка: Почта пользователя не найдена в SharedPreferences');
      return;
    }
    var url = Uri.parse('http://localhost:3000/users/profile_one');
    var body = jsonEncode({
      'user_email': userEmail,
      'department': department,
      'professor': teacher,
    });
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      logger.e('Данные успешно отправлены');
    } else {
      logger.e('Ошибка отправки данных: ${response.statusCode}');
    }
  }
  Future<List<String>> fetchDepartments() async {
    final response = await http.get(Uri.parse('http://localhost:3000/departament'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      logger.i("department statusCode 200");
      return data.map((item) => item['name'] as String).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }
  Future<void> fetchProfessors(String department) async {
    final response = await http.get(Uri.parse('http://localhost:3000/professor/$department'));
    if (response.statusCode == 200) {
      logger.i("professor statusCode 200");
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _professors = data.map((item) => item['name'] as String).toList();
      });
    } else {
      throw Exception('Failed to load professors');
    }
  }
  Future<List<String>> fetchFaculties() async {
    final response = await http.get(Uri.parse('http://localhost:3000/faculties'));
    if (response.statusCode == 200) {
      logger.i("faculties statusCode 200");
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['faculty_name'] as String).toList();
    } else {
      throw Exception('Failed to load faculties');
    }
  }
  Future<void> fetchDirections(String faculty) async {
    final response = await http.get(Uri.parse('http://localhost:3000/directions/$faculty'));
    if (response.statusCode == 200) {
      logger.i("directions statusCode 200");
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _directions = data.map((item) => item['direction_abbreviation'] as String).toList();
      });
    } else {
      throw Exception('Failed to load directions');
    }
  }
  Future<void> fetchGroups(String directionId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/group_name/$directionId'));
    if (response.statusCode == 200) {
      logger.i("group_name statusCode 200");
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _groups = data.map((item) => item['name'] as String).toList();
      });
    } else {
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFF6226A6),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Профиль',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     // Обработчик нажатия на кнопку "Выход"
                              //     // Реализуйте здесь код для выхода пользователя
                              //   },
                              //   child: Text(
                              //     'Выход',
                              //     style: TextStyle(
                              //       fontSize: 20,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 150,
                          height: 75,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 75,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'ФИО',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38.0),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedRole = 'Студент';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (states) => _selectedRole == 'Студент' ? Colors.white : Colors.white,
                              ),
                              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (states) => _selectedRole == 'Студент' ? Colors.purple : Colors.black54,
                              ),
                              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                    (states) => const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    bottomLeft: Radius.circular(16.0),
                                  ),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.resolveWith<Size>(
                                    (states) => const Size(double.infinity, 48.0),
                              ),
                            ),
                            child: const Text('Студент'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedRole = 'Преподаватель';
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (states) => _selectedRole == 'Преподаватель' ? Colors.white : Colors.white,
                              ),
                              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (states) => _selectedRole == 'Преподаватель' ? Colors.purple : Colors.black54,
                              ),
                              shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                    (states) => const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0),
                                  ),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.resolveWith<Size>(
                                    (states) => const Size(double.infinity, 48.0),
                              ),
                            ),
                            child: const Text('Преподаватель'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedRole == 'Студент') ...[
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedFaculty,
                        items: _faculties.map((String faculty) {
                          return DropdownMenuItem<String>(
                            value: faculty,
                            child: Text(faculty),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFaculty = value;
                            fetchDirections(value!);
                          });
                        },
                        hint: const Text('Факультет'),
                        icon: const Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedDirection.isNotEmpty ? _selectedDirection[0] : null,
                        items: _directions.map((String direction) {
                          return DropdownMenuItem<String>(
                            value: direction,
                            child: Text(direction),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDirection = [value!];
                            fetchGroups(value);
                          });
                        },
                        hint: const Text('Направление'),
                        icon: const Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedGroup,
                        items: _groups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              if (!_selectedGroups.contains(value)) {
                                _selectedGroups.add(value);
                              }
                              _selectedGroup = value;
                            }
                          });
                        },
                        hint: const Text('Группа'),
                        icon: const Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedSubgroup,
                        items: _subgroups.map((String subgroup) {
                          return DropdownMenuItem<String>(
                            value: subgroup,
                            child: Text(subgroup),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubgroup = value;
                          });
                          if (_selectedFaculty != null && _selectedDirection.isNotEmpty && _selectedGroup != null && value != null) {
                            sendDataToServers(_selectedFaculty!, _selectedDirection![0], _selectedGroup!, value);
                          }
                        },
                        hint: const Text('Подгруппа'),
                        icon: const Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
                if (_selectedRole == 'Преподаватель') ...[
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedDepartment,
                        itemHeight: 60,
                        items: _departments.map((String department) {
                          return DropdownMenuItem<String>(
                            value: department,
                            child: Text(truncateDepartmentName(department, 54)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                            fetchProfessors(value!);
                          });
                        },
                        hint: const Text('Кафедра'),
                        icon: const Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedTeacher,
                        items: _professors.map((String teacher) {
                          return DropdownMenuItem<String>(
                            value: teacher,
                            child: Text(teacher),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeacher = value;
                          });
                          if (_selectedDepartment != null && _selectedTeacher != null) {
                            sendDataToServer(_selectedDepartment!, _selectedTeacher!);
                          }
                        },
                        hint: const Text('Преподаватель'),
                        icon: const Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}