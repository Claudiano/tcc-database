#!/bin/bash

#

echo "Inicia postgres"

DB_USER="postgres"
CONTAINER_NAME="database"
POSTGRES_DB="tccDB"

#DB_PASSWORD="$2"
IP_DATABASE=192.168.16.1

#docker-compose build app

# pega senha
DB_PASSWORD=$(sudo docker run --rm --device "/dev/isgx" -it app-db python3 app.py 1 $IP_DATABASE 0)

# Inicia o banco

# Subir ccontainer do banco
#docker-compose run -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD database
#docker-compose up -d database
#docker-compose up -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD database

echo $DB_PASSWORD
echo "ip do banco: " $IP_DATABASE

# realizar post da sessão do banco
#CONTAINER_NAME='mycontainername'

if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
  echo exists
  sudo docker start ${CONTAINER_NAME}
else
  # Criar o container do banco 
  echo 'does not exist'
  sudo docker run --name $CONTAINER_NAME -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD -e POSTGRES_DB=$POSTGRES_DB  postgres:9.6
fi


