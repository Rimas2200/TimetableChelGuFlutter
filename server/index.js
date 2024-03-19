const express = require('express');
const mysql = require('mysql');

const app = express();
app.use(express.json());

const dbConfig = {
  host: '127.0.0.1',
  user: 'root',
  password: '',
  database: 'timetable',
};

const pool = mysql.createPool(dbConfig);
app.post('/register', (req, res) => {
  const { name, password } = req.body;

  if (!name || !password) {
    return res.status(400).json({ error: 'Invalid data' });
  }

  const hashedPassword = hashPassword(password);
  const query = 'INSERT INTO users (name, password) VALUES (?, ?)';
  const values = [name, hashedPassword];

  pool.getConnection((err, connection) => {
    if (err) {
      console.error('Error occurred during database connection:', err);
      return res.status(500).json({ error: 'Database connection error' });
    }

    connection.query(query, values, (error, results) => {
      connection.release();

      if (error) {
        console.error('Error occurred during registration:', error);
        return res.status(500).json({ error: 'Registration failed' });
      }

      return res.status(200).json({ message: 'Registration successful' });
    });
  });
});

function hashPassword(password) {
  return password;
}

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});