#!/bin/bash

#

echo "Inicia postgres"

DB_USER="postgres"
CONTAINER_NAME="database"
POSTGRES_DB="tccDB"

#DB_PASSWORD="$2"
IP_DATABASE=192.168.16.1

#docker-compose build app

function determine_sgx_device {
    export SGXDEVICE="/dev/sgx"
    export MOUNT_SGXDEVICE="-v /dev/sgx/:/dev/sgx"
    if [[ ! -e "$SGXDEVICE" ]] ; then
        export SGXDEVICE="/dev/isgx"
        export MOUNT_SGXDEVICE="--device=/dev/isgx"
        if [[ ! -c "$SGXDEVICE" ]] ; then
            echo "Warning: No SGX device found! Will run in SIM mode." > /dev/stderr
            export MOUNT_SGXDEVICE=""
            export SGXDEVICE=""
        fi
    fi
}

determine_sgx_device

echo $SGXDEVICE

# pega senha
DB_PASSWORD=$(sudo docker run $MOUNT_SGXDEVICE --rm -it app-db python3 app.py 1 $IP_DATABASE 0)

# Inicia o banco

# Subir ccontainer do banco
#docker-compose run -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD database
#docker-compose up -d database
#docker-compose up -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD database

echo $DB_PASSWORD
echo "ip do banco: " $IP_DATABASE
echo $DB_USER
echo $CONTAINER_NAME
echo $POSTGRES_DB



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


