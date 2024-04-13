const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const pool = mysql.createPool({
  host: '127.0.0.1',
  user: 'root',
  database: 'timetable',
  password: '',
});

app.use(express.json());
app.use(cors()); 

// Обработчики GET-запросов
app.get('/', (req, res) => {
  res.send('Добро пожаловать на сервер!');
});
app.get('/register', (req, res) => {
  res.send('Регистрация нового пользователя');
});
app.get('/auth', (req, res) => {
  res.send('Авторизация нового пользователя');
});

// Обработчик POST-запроса на /register
app.post('/register', (req, res) => {
  const { username, email, password } = req.body;
  console.log(req.body)
  if (!(username || email || password)) {
    return res.status(409).json({ error: 'Данные не соответствуют запросу' });
  }
  console.log(username)
  if (userExists(username)) {
    return res.status(416).json({ error: 'Имя пользователя уже существует' });
  }
  const newUser = {
    username,
    email,
    password,
  };
  
  saveUser(newUser)
    .then(() => {
      res.status(200).json(newUser);
    })
    .catch((error) => {
      console.error('Ошибка сохранения пользователя:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    });
});
function userExists(username) {
  // Здесь должна быть логика проверки наличия пользователя в базе данных
  // Верните true, если пользователь существует, и false в противном случае
  // Ниже приведен пример проверки наличия пользователя в простом массиве
  const users = ['user1', 'user2', 'user3'];
  return users.includes(username);
}
//сохранение пользователя в бд
function saveUser(user) {
  return new Promise((resolve, reject) => {
    const query = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
    const values = [user.username, user.email, user.password];

    pool.query(query, values, (error, results) => {
      if (error) {
        reject(error);
      } else {
        resolve(results);
      }
    });
  });
}

// Обработчик POST-запроса на /auth
app.post('/auth', (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(416).json({ error: 'Данные не соответствуют запросу' });
  }
  authenticateUser(email, password)
    .then((authenticated) => {
      if (authenticated) {
        res.status(200).json({ message: 'Пользователь успешно авторизован' });
      } else {
        res.status(401).json({ error: 'Не авторизован' });
      }
    })
    .catch((error) => {
      console.error('Ошибка проверки авторизации:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    });
});

// Функция проверки авторизации пользователя в бд
function authenticateUser(email, password) {
  return new Promise((resolve, reject) => {
    const query = 'SELECT * FROM users WHERE email = ? AND password = ?';
    const values = [email, password];

    pool.query(query, values, (error, results) => {
      if (error) {
        reject(error);
      } else {
        const authenticated = results.length > 0;
        resolve(authenticated);
      }
    });
  });
}





// Запуск сервера
app.listen(3000, () => {
  console.log('Сервер запущен на порту 3000');
  pool.getConnection((error, connection) => {
    if (error) {
      console.error('Ошибка подключения к базе данных:', error);
      return;
    }
    console.log('Соединение с базой данных успешно установлено.');
    connection.query('SELECT 1 + 1 AS result', (error, results) => {
      if (error) {
        console.error('Ошибка выполнения запроса:', error);
        return;
      }
      console.log('Результат запроса:', results[0].result);
      connection.release(); // Освобождение соединения обратно в пул
      console.log('Соединение с базой данных успешно закрыто.');
    });
  });
});