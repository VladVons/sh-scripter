#!/bin/bash

source ../host.sh

ImgRun()
{
    docker run \
        --detach \
        --name db_mysql \
        --publish 3306:3306 \
        --env MYSQL_ROOT_PASSWORD=19710819 \
        --volume mysql:/var/lib/mysql \
        mysql:latest
}

Connect_Docker()
{
    docker exec \
        -it mysql_db \
        mysql -p
}


#docker container ls -a
#docker stop mysql
#docker rm mysql

docker ps -a
echo

#ImgRun
#mysql -u root -p -h 127.0.0.1
CntAttach db_mysql &
