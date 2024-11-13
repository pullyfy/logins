import sqlite3
import urllib.parse
from flask import Flask, request

# variables
password = 'ni7z?WUl'
db_path = r'files/database.db'

class database():
    def __init__(self, db_path):
        self.connection = sqlite3.connect(db_path)
        self.cursor = self.connection.cursor()
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS userdata(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            discord TEXT,
            hash TEXT,
            hwid INTEGER,
            is_beta INTEGER
            );
        """); self.connection.commit()
    
    def insert(self, data):
        self.cursor.execute("""INSERT INTO userdata(discord, hash, hwid, is_beta) VALUES({});""".format(data))
        self.connection.commit()
    def update(self, data):
        self.cursor.execute('''UPDATE userdata {}'''.format(data))
        self.connection.commit()
    def select(self, data):
        self.cursor.execute(data)
        selected = self.cursor.fetchone()
        print(selected, type(selected))
        if selected == None:
            return 'nil'
        else:
            return selected[0]
    def delete(self, data):
        self.cursor.execute('''DELETE FROM userdata WHERE {}'''.format(data))
        self.connection.commit()
    def select_all(self):
        self.cursor.execute("SELECT * FROM userdata;")
        return self.cursor.fetchall()
    def close_connection(self, debug):
        if debug:
            print(self.select_all())
        self.connection.close()
# end class
def byted_string_to_dict(b_str):
    decoded_params = urllib.parse.parse_qs(b_str.decode('utf-8'))
    return {key: value[0] for key, value in decoded_params.items()}
#

# server start
app = Flask(__name__)

@app.route('/insert', methods = ['POST'])
def insert():
    data = byted_string_to_dict(request.get_data())
    if data['password'] != password:
        return 'Bad password!'
    base = database(db_path)

    base.insert(data['sql'])

    base.close_connection(True)
    return 'Data succesfully inputed.'
#
@app.route('/update', methods = ['POST'])
def update():
    data = byted_string_to_dict(request.get_data())
    if data['password'] != password:
        return 'Bad password!'
    base = database(db_path)

    base.update(data['sql'])

    base.close_connection(True)
    return 'Data succesfully updated.'
#
@app.route('/select', methods = ['POST'])
def select():
    data = byted_string_to_dict(request.get_data())
    if data['password'] != password:
        return 'Bad password!'
    base = database(db_path)

    value = base.select(data['sql'])

    base.close_connection(True)
    return str(value)
#

if __name__ == '__main__':
    app.run(host = '185.154.194.12', port = 1700)
# server end