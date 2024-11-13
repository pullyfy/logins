import sqlite3
import random

hash = random.getrandbits(128)
hash = "%032x" % hash

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
        return self.cursor.fetchone()[0]
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

base = database(r'files/database.db')
def generate_hash(discord, is_beta):
    print('copy: {}'.format(hash))
    base.insert(" '{}', '{}', 0, {}".format(discord, hash, is_beta and 1 or 0))
    base.close_connection(True)
#
generate_hash('pullyfy', True)