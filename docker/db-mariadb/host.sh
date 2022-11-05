#!/bin/bash

source ../host.sh

ImgRun()
{
    docker run \
        --detach \
        --name db_mariadb \
        --env MARIADB_ROOT_PASSWORD=19710819 \
        --publish 3306:3306 \
        mariadb:latest
}

docker ps -a
echo

#ImgRun
#mysql -u root -p -h 127.0.0.1
CntAttach db_mariadb &
