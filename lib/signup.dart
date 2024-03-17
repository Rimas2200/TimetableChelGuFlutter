import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

// ignore: use_key_in_widget_constructors
class SignUpPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundSignUp(),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 25.0, top: 35.0),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getInputs(),
                  _getSignUp(),
                  _getBottomRow(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(
      alignment: Alignment.bottomLeft,
      child: const Text(
        'Регистрация аккаунта',
        style: TextStyle(color: Colors.white, fontSize: 37),
      ),
    ),
  );
}

Future<void> writeToDatabase(String name, String email, String password) async {
  final settings = ConnectionSettings(
    host: '127.0.0.1',
    port: 3306,
    user: '',
    password: '',
    db: 'timetable',
  );

  final conn = await MySqlConnection.connect(settings);

  try {
    // ignore: unused_local_variable
    final result = await conn.query(
      'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
      [name, email, password],
    );

    print('Данные успешно записаны в базу данных');
  } catch (e) {
    print('Ошибка при записи данных: $e');
  } finally {
    await conn.close();
  }
}

_getInputs() {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  return Expanded(
    flex: 4,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: 'Имя',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: 'E-mail',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelText: 'Пароль',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    ),
  );
}

_getSignUp() {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  return Expanded(
    flex: 2,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            String email = emailController.text;
            String password = passwordController.text;
            writeToDatabase(name, email, password);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: const Text(
            'Регистрация',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          radius: 40,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        )
      ],
    ),
  );
}

_getBottomRow(context) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Вход',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline),
          ),
        ),
      ],
    ),
  );
}

class BackgroundSignUp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.5, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = Colors.lightBlue.shade300;
    canvas.drawPath(blueWave, paint);

    Path greyPath = Path();
    greyPath.lineTo(sw, 0);
    greyPath.lineTo(sw, sh * 0.3);
    greyPath.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyPath.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}