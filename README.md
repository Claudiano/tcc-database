
Inicia o banco com usuario padrão
docker-compose up -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres database


bind-address=0.0.0.0

https://github.com/docker/compose/issues/2999# tcc-database


docker run --rm  $MOUNT_SGXDEVICE -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e SCONE_HEAP=256M -e SCONE_MODE=HW -e SCONE_ALLOW_DLOPEN=2 -e SCONE_ALPINE=1 -e SCONE_VERSION=1 sconecuratedimages/apps:python-2-alpine3.6 python myapp.py

