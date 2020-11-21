import os
#import subprocess
import random
import string
import sys

import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def randompassword(number):
    chars = random.sample(string.ascii_lowercase + string.digits, number)
    passw = ''.join(map(str, chars))
    return passw

def createDatabaseCredentials(userDefault, passwordDefault, ipDatabase):
    newUser     = randompassword(8)
    newPassword = randompassword(10)

    # Usuarios padroes do banco
    # userDefault     = os.getenv("USER_DEFAULT")
    # passwordDefault = os.getenv("PASSWORD_DEFAULT")

    print(userDefault, passwordDefault)
    print("Credenciais:", newUser, "Snha:", newPassword)

    sqlCreateUser = "CREATE ROLE "+newUser+ " WITH SUPERUSER PASSWORD '" + newPassword +"';"
    sqlDeleteUser = "DROP USER " + userDefault + ";"

    #conecta com usuario default
    con = psycopg2.connect(host=ipDatabase, database='tccDB', user=userDefault, password=passwordDefault)
    #  "user="+ userDefault + " password='" + passwordDefault + "'")
    con.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    '''
    # Cria nono usuario no banco
    cursor = con.cursor()
    cursor.execute(sqlCreateUser)
    
    # Excluir ou desabilitar usuario default do banco
    conSec = psycopg2.connect(host=ipDatabase, database='tccDB', user=newUser, password=newPassword)
    conSec.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)

    # Excluir usuario no banco
    cursorSec = conSec.cursor()
    cursorSec.execute(sqlDeleteUser)
    '''
    # Retornar as novas credenciais para serem postada

    #path = "./uploadSession.sh " + newUser + " " + newPassword
    #return_code = subprocess.call(path, shell=True)
    
    print(newUser, newPassword)
    

USER_DATABASE = os.getenv("USER_DATABASE")
PASSWORD_DATABASE = os.getenv("PASSWORD_DATABASE")

# pega os valores passados pelo script
#print(sys.argv)
method = sys.argv[1]
ipDatabase = sys.argv[2]
passwordDefault = sys.argv[3]


userDefault = 'postgres'


if method == "1":
    print(randompassword(8))
elif method == "0":
    if not USER_DATABASE and not PASSWORD_DATABASE:
        createDatabaseCredentials(userDefault, passwordDefault, ipDatabase)
    # USER_DATABASE = os.getenv("USER_DATABASE")
    # PASSWORD_DATABASE = os.getenv("PASSWORD_DATABASE")

# verifica se postgres(default) está habilitado, se estiver criar um novo e exclui ele


