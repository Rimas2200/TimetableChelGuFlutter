const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const app = express();
const pool = mysql.createPool({
  host: '127.0.0.1',
  user: 'root',
  database: 'respGlobalChange',
  password: '',
});

app.use(express.json());
app.use(cors()); 

//app.get('/', (req, res) => {
//  res.send('Добро пожаловать на сервер!');
//});

app.get('/faculties', (req, res) => {
  // Запрос на получение списка факультетов из базы данных
  pool.query('SELECT * FROM faculty', (error, results) => {
    if (error) {
      // Если произошла ошибка при выполнении запроса
      console.error('Ошибка при выполнении запроса:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    } else {
      // Если запрос выполнен успешно, проверяем, есть ли результаты
      if (results && results.length > 0) {
        // Если есть результаты, отправляем список факультетов на клиент
        res.json(results);
      } else {
        // Если результаты отсутствуют, отправляем пустой список
        res.json([]);
      }
    }
  });
});
app.get('/departament', (req, res) => {
  // Запрос на получение списка кафедр из базы данных
  pool.query('SELECT * FROM departament', (error, results) => {
    if (error) {
      // Если произошла ошибка при выполнении запроса
      console.error('Ошибка при выполнении запроса:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    } else {
      // Если запрос выполнен успешно, проверяем, есть ли результаты
      if (results && results.length > 0) {
        // Если есть результаты, отправляем список факультетов на клиент
        res.json(results);
      } else {
        // Если результаты отсутствуют, отправляем пустой список
        res.json([]);
      }
    }
  });
});
app.get('/professor/:department', (req, res) => {
  const department = req.params.department;
  // Запрос на получение списка профессоров из базы данных для выбранной кафедры
  pool.query('SELECT CONCAT(last_name, " ", LEFT(first_name, 1), ". ", LEFT(middle_name, 1), ".") AS name FROM professor WHERE departement = ?', [department], (error, results) => {
    if (error) {
      console.error('Ошибка при выполнении запроса:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    } else {
      if (results && results.length > 0) {
        res.json(results);
      } else {
        res.json([]);
      }
    }
  });
});


app.get('/directions/:facultyId', (req, res) => {
  const facultyId = req.params.facultyId;
  // Запрос на получение списка направлений обучения по выбранному факультету
  pool.query('SELECT direction_abbreviation FROM direction WHERE faculty = ?', [facultyId], (error, results) => {
    if (error) {
      // Если произошла ошибка при выполнении запроса
      console.error('Ошибка при выполнении запроса:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    } else {
      // Если запрос выполнен успешно, проверяем, есть ли результаты
      if (results && results.length > 0) {
        // Если есть результаты, отправляем список направлений на клиент
        res.json(results);
      } else {
        // Если результаты отсутствуют, отправляем пустой список
        res.json([]);
      }
    }
  });
});
app.get('/group_name/:directionId', (req, res) => {
  const directionId = req.params.directionId;
  // Запрос на получение списка групп по выбранному направлению
  pool.query('SELECT name FROM group_name WHERE direction_abbreviation = ?', [directionId], (error, results) => {
    if (error) {
      console.error('Ошибка при выполнении запроса:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
    } else {
      if (results && results.length > 0) {
        res.json(results);
      } else {
        res.json([]);
      }
    }
  });
});




// Обработчик POST-запроса на /register
app.post('/register', async (req, res) => {
  const { username, email, password } = req.body;
  console.log(req.body)
  if (!(username && email && password)) {
    return res.status(409).json({ error: 'Данные не соответствуют запросу' });
  }
  console.log(email)
  try {
    const exists = await userExists(email);
    if (exists) {
      return res.status(416).json({ error: 'Пользователь с такой почтой уже существует' });
    }
    const newUser = {
      username,
      email,
      password,
    };

    await saveUser(newUser);
    res.status(200).json(newUser);
  } catch (error) {
    console.error('Ошибка сохранения пользователя:', error);
    res.status(500).json({ error: 'Ошибка сервера' });
  }
});

function userExists(email) {
  return new Promise((resolve, reject) => {
    const query = 'SELECT COUNT(*) AS count FROM users WHERE email = ?';
    const values = [email];

    pool.query(query, values, (error, results) => {
      if (error) {
        reject(error);
      } else {
        const count = results[0].count;
        resolve(count > 0);
        console.log(count)
      }
    });
  });
}
// userExists('username').then((exists) => {
//   console.log(exists); // Результат запроса (true или false)
// }).catch((error) => {
//   console.error(error); // Обработка ошибки, если запрос завершился неудачей
// });

//сохранение пользователя в бд
function saveUser(user) {
  return new Promise((resolve, reject) => {
    const query = 'INSERT INTO users (username, email, password, token) VALUES (?, ?, ?, ?)';
    const values = [user.username, user.email, user.password, "token"];

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
  
  const secretKey = crypto.randomBytes(32).toString('hex');
  // Генерация токена
  const token = jwt.sign({ email }, secretKey);
  
  authenticateUser(email, password, token)
    .then((authenticated) => {
      if (authenticated) {
        // Отправка токена в ответе
        res.status(200).json({ token });
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
function authenticateUser(email, password, token) {
  return new Promise((resolve, reject) => {
    const query = 'SELECT * FROM users WHERE email = ? AND password = ?';
    const values = [email, password];
    // console.log(username, password)
    pool.query(query, values, (error, results) => {
      if (error) {
        reject(error);
      } else {
        const authenticated = results.length > 0;
        if (authenticated) {
          const updateQuery = 'UPDATE users SET token = ? WHERE email = ?';
          const updateValues = [token, email];
          pool.query(updateQuery, updateValues, (error, results) => {
            if (error) {
              reject(error);
            } else {
              resolve(authenticated);
            }
          });
        } else {
          resolve(authenticated);
        }
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