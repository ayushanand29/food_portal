import pymysql
import json
from flask import Flask
from flaskext.mysql import MySQL
from flask import jsonify
from flask import flash, request


def readConfig():
    with open("/home/nithin/Desktop/ankith/gusto/config.json") as json_data:
        data = json.load(json_data)
    return data


def connectToDb(data, app):
    # MySQL configurations
    app.config['MYSQL_DATABASE_USER'] = data['user']
    app.config['MYSQL_DATABASE_PASSWORD'] = data['password']
    app.config['MYSQL_DATABASE_DB'] = data['database']
    app.config['MYSQL_DATABASE_HOST'] = data['host']
    mysql.init_app(app)


app = Flask(__name__)
mysql = MySQL()
