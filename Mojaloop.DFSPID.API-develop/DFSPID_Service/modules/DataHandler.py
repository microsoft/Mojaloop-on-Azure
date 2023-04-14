import mysql.connector
import os
from mysql.connector import MySQLConnection,Error
from DFSPID_Service import my_logger
import mysql.connector
from mysql.connector import Error

def create_db_config():
    db = {'host': os.environ.get('MYSQL_SERVER','localhost') , 'database': os.environ.get('MYSQL_DATABASE','python_mysql'), 'user': os.environ.get('MYSQL_USER','root'), 'password': os.environ.get('MYSQL_PASSWORD','SecurePass1!'),'port': os.environ.get('MYSQL_PORT','3306')}
    return db

def connectionTest():
    """Connect to MySQL Database"""
    exitCode = 1
    conn = None
    try:
        conn = mysql.connector.connect(host=os.environ.get('MYSQL_SERVER','localhost'),
                                       database=os.environ.get('MYSQL_DATABASE','python_mysql'),
                                       user=os.environ.get('MYSQL_USER','root'),
                                       password=os.environ.get('MYSQL_PASSWORD','SecurePass1!'),
                                       port=os.environ.get('MYSQL_PORT','3306'))
        if conn is not None and conn.is_connected():
            conn.close()
    except Error as e:
        if conn is not None and conn.is_connected():
            conn.close()
        my_logger.error(e)
        raise Exception(e)

def LookupDFSPID(dfspid):
    """Connect to MySQL Database"""
    exitCode = 1
    conn = None
    err = None
    try:
        dbconfig = create_db_config()
        conn = MySQLConnection(**dbconfig)
        cursor = conn.cursor()
        cursor.execute("{0} '{1}'".format(os.environ.get("VALIDATION_QUERY","SELECT * FROM participant WHERE participantId = "),dfspid))
        row = cursor.fetchall()
        exitCode = 0
        if cursor.rowcount < 1:
            exitCode = 1
    except Error as e:
        my_logger.error(e)
        err = e
        exitCode = 1
    finally:
        if conn is not None and conn.is_connected():
            try:
                cursor.close()
            except:
                my_logger.warn("Cursor already closed!")
            conn.close()
        return exitCode,err