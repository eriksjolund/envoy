import sys

from flask import Flask

import psycopg2

def connect_to_postgres(host, port):
  conn = psycopg2.connect("host={} user=postgres port={}".format(host, port))
  cur = conn.cursor()
  cur.execute('SELECT version()')
  msg = 'Connected to Postgres, version: %s' % cur.fetchone()
  cur.close()
  conn.close()
  return msg

app = Flask(__name__)

@app.route('/')
def hello():
  msg = ''
  msg = msg + connect_to_postgres('proxy-postgres-frontend', 5432) + " "
  msg = msg + connect_to_postgres('proxy-postgres-frontend', 5433)
  return msg

if __name__ == "__main__":
  app.run(host='0.0.0.0', port=8000, debug=True)
