import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RegistrationTab extends StatefulWidget {
  @override
  _RegistrationTabState createState() => _RegistrationTabState();
}

class _RegistrationTabState extends State<RegistrationTab> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> registerUser() async {
    final url = 'http://*:3000/register/';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // Пользователь успешно зарегистрирован
      print('Пользователь успешно зарегистрирован');
    } else {
      // Обработка ошибки регистрации
      print('Ошибка регистрации: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Имя пользователя',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пароль',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}