import sys

from flask import Flask

import psycopg2

app = Flask(__name__)


@app.route('/')

def connect_to_postgres(host, port):
  conn = psycopg2.connect(f"host={host} user=postgres port={port}")
  cur = conn.cursor()
  cur.execute('SELECT version()')
  msg = 'Connected to Postgres, version: %s' % cur.fetchone()
  cur.close()
  return msg

def hello():
  msg = ''
  msg = msg + connect_to_postgres('proxy-postgres-frontend.example.com', 5432)
  msg = msg + connect_to_postgres('proxy-postgres-frontend.example.com', 5433)
  return msg

if __name__ == "__main__":
  app.run(host='0.0.0.0', port=8000, debug=True)
