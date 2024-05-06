import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _selectedRole = 'Студент'; // Изначально выбрана роль "Студент"
  String? _selectedFaculty;
  String? _selectedDirection;
  String? _selectedGroup;
  String? _selectedSubgroup;
  String? _selectedTeacher;
  String? _selectedDepartment;

  List<String> _faculties = ['Факультет 1', 'Факультет 2', 'Факультет 3']; // Примеры значений для выпадающих списков
  List<String> _directions = ['Направление 1', 'Направление 2', 'Направление 3'];
  List<String> _groups = ['Группа 1', 'Группа 2', 'Группа 3'];
  List<String> _subgroups = ['Подгруппа 1', 'Подгруппа 2', 'Подгруппа 3'];
  List<String> _teachers = ['Преподаватель 1', 'Преподаватель 2', 'Преподаватель 3'];
  List<String> _departments = ['Кафедра 1', 'Кафедра 2', 'Кафедра 3'];


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
                  color: Color(0xFF6226A6), // Цвет верхнего блока 6226A6
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Профиль', // Текст, который нужно отобразить
                                style: TextStyle(
                                  fontSize: 30, // Размер шрифта
                                  fontWeight: FontWeight.w500, // Насыщенность шрифта
                                  color: Colors.white, // Цвет текста
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
                        SizedBox(height: 10), // Расстояние между текстом и окружностью
                        Container(
                          width: 150, // Ширина полуокружности
                          height: 75, // Высота полуокружности
                          decoration: BoxDecoration(
                            color: Colors.black12, // Цвет полуокружности
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100), // Радиус окружности
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
                  color: Color(0xFFFFFFFF), // Цвет верхнего блока 6226A6
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Container(
                          width: 150, // Ширина полуокружности
                          height: 75, // Высота полуокружности
                          decoration: BoxDecoration(
                            color: Colors.black12, // Цвет полуокружности
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100), // Радиус окружности
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Расстояние между окружностью и текстом
                        Text(
                          'ФИО', // Текст, который нужно отобразить
                          style: TextStyle(
                            fontSize: 30, // Размер шрифта
                            fontWeight: FontWeight.w600, // Насыщенность шрифта
                            color: Colors.black, // Цвет текста
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
            padding: EdgeInsets.symmetric(horizontal: 38.0),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12, // Цвет рамки
                        width: 2.0, // Ширина рамки
                      ),
                      borderRadius: BorderRadius.circular(16.0), // Скругление углов
                    ),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
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
                                  (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0),
                                ),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.resolveWith<Size>(
                                  (states) => Size(double.infinity, 48.0), // Вы можете изменить ширину кнопки, изменяя значение double.infinity или другое значение
                            ),
                          ),
                          child: Text('Студент'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.0),
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
                                  (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.resolveWith<Size>(
                                  (states) => Size(double.infinity, 48.0), // Вы можете изменить ширину кнопки, изменяя значение double.infinity или другое значение
                            ),
                          ),
                          child: Text('Преподаватель'),
                        ),
                      ),
                    ),
                  ],
                ),
                ),


                if (_selectedRole == 'Студент') ...[
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
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
                          });
                        },
                        hint: Text('Факультет'),
                        icon: Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                      child :SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedDirection,
                        items: _directions.map((String direction) {
                          return DropdownMenuItem<String>(
                            value: direction,
                            child: Text(direction),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDirection = value;
                          });
                        },
                        hint: Text('Направление'),
                        icon: Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
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
                            _selectedGroup = value;
                          });
                        },
                        hint: Text('Группа'),
                        icon: Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
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
                        },
                        hint: Text('Подгруппа'),
                        icon: Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ],
                if (_selectedRole == 'Преподаватель') ...[
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedTeacher,
                        items: _teachers.map((String teacher) {
                          return DropdownMenuItem<String>(
                            value: teacher,
                            child: Text(teacher),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeacher= value;
                          });
                        },
                        hint: Text('Преподаватель'),
                        icon: Icon(Icons.expand_more_rounded),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _selectedDepartment,
                        items: _departments.map((String department) {
                          return DropdownMenuItem<String>(
                            value: department,
                            child: Text(department),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                        hint: Text('Кафедра'),
                        icon: Icon(Icons.expand_more_rounded),
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
  }}