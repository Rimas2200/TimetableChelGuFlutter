import mysql.connector   #pip install mysql-connector-python
import sqlite3

sqlite_connection = sqlite3.connect('sql/timetable_db_test.db')
cursor = sqlite_connection.cursor()

cursor.execute('SELECT * FROM timetable')
rows = cursor.fetchall()

cursor.close()
sqlite_connection.close()

mysql_connection = mysql.connector.connect(
    host='127.0.0.1',
    user='',
    password='',
    database='timetable'
)
cursor = mysql_connection.cursor()

create_table_query = '''
    CREATE TABLE IF NOT EXISTS timetable(
        id INT AUTO_INCREMENT PRIMARY KEY,
        discipline TEXT, 
        classroom TEXT, 
        group_name TEXT,
        pair_number TEXT, 
        teacher_name TEXT,
        day_of_the_week TEXT,
        week TEXT,
        subgroup TEXT
    )
'''
cursor.execute(create_table_query)

cursor.close()
mysql_connection.close()

mysql_connection = mysql.connector.connect(
    host='localhost',
    user='root',
    password='',
    database='timetable'
)
cursor = mysql_connection.cursor()

insert_query = '''
    INSERT INTO timetable (
        discipline, classroom, group_name,
        pair_number, teacher_name, day_of_the_week,
        week, subgroup
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
'''

for row in rows:
    cursor.execute(insert_query, row[1:])
mysql_connection.commit()

cursor.close()
mysql_connection.close()