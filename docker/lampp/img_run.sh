#!/bin/bash

# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lampp

source ./docker.conf
source ./docker/log/log.sh

cCntName="lampp2"

Run()
{
    echo "$0->$FUNCNAME($*)"

    docker run \
        --name $cCntName \
        --publish 10021:21 \
        --publish 10022:22 \
        --publish 80:80 \
        --publish 3306:3306 \
        --publish 5432:5432 \
        $cImgName
        #--volume ${PWD}/mnt/www:/var/www \
        #--volume ${PWD}/mnt/mysql:/var/lib/mysql \
        #--volume ${PWD}/mnt/postgresql:/var/lib/postgresql \

}

Restore()
{
    echo "$0->$FUNCNAME($*)"

    docker start $cCntName
    docker attach $cCntName
}

Help()
{
    ssh admin@localhost -p 10022

    mysql -u admin -p -h 127.0.0.1
    mysql -u admin -p -h 127.0.0.1 -e "CREATE DATABASE test2;"

    psql -h localhost -U admin -d test1
    psql -h localhost -U admin -d template1 -c "CREATE DATABASE test2;"

    netstat -tln | grep 'tcp '

    sudo echo "127.0.0.1 php74.lan php81.lan" >> /etc/hosts
}


rm /home/vladvons/.ssh/known_hosts

docker ps -a
if [ "$(docker ps -a | grep $cImgName)" ]; then
    Restore
else
    Run
fi
