import sqlite3
import re
import discord
from discord.ext import commands
import random

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

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix = '>', intents = intents)
base = database(r'files/database.db')
admin_member_id = [394043716912021505]

def generate_hash(discord, is_beta):
    print('copy: {}'.format(hash))
    base.insert(" '{}', '{}', 0, {}".format(discord, hash, is_beta and 1 or 0))
    base.close_connection(True)
#
@bot.command(pass_context = True)
async def add_user(ctx, user: str, is_beta: bool):
    if ctx.author.id in admin_member_id:
        hash = "%032x" % random.getrandbits(128)
        user = str(await bot.fetch_user(int(re.findall(r'\d+', str(user))[0])))

        base = database(r'files/database.db')
        base.insert(" '{}', '{}', 0, {}".format(user, hash, is_beta and 1 or 0))
        base.close_connection(True)

        await ctx.send('{} key ```{}```'.format(user, hash))
    else:
        await ctx.send('You don`t have permission.')
#
@bot.command(pass_context = True)
async def delete_user(ctx, user: str):
    if ctx.author.id in admin_member_id:
        user = str(await bot.fetch_user(int(re.findall(r'\d+', str(user))[0])))

        base = database(r'files/database.db')
        base.delete("discord = '{}'".format(user))
        base.close_connection(True)

        await ctx.send('User {} succesfully deleted.'.format(user))
    else:
        await ctx.send('You don`t have permission.')
#

bot.run('')