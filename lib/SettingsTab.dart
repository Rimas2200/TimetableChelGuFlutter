import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Тёмная тема'),
            trailing: Switch(
              value: _isDarkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isDarkModeEnabled = value;
                  _changeTheme(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _changeTheme(bool isDarkModeEnabled) {
    if (isDarkModeEnabled) {
      // Сменить на темную тему
      _setDarkMode();
    } else {
      // Сменить на светлую тему
      _setLightMode();
    }
  }

  void _setDarkMode() {
    // Здесь вы можете задать цвета для темной темы
    // Например:
    // final ThemeData darkTheme = ThemeData.dark().copyWith(
    //   // ваша настройка темной темы
    // );
    // MyApp.setTheme(darkTheme); // MyApp - ваш класс приложения
  }

  void _setLightMode() {
    // Здесь вы можете задать цвета для светлой темы
    // Например:
    // final ThemeData lightTheme = ThemeData.light().copyWith(
    //   // ваша настройка светлой темы
    // );
    // MyApp.setTheme(lightTheme); // MyApp - ваш класс приложения
  }
}
