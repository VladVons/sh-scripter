#!/bin/bash

# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lampp

source ./docker.conf
source ./docker/log.sh

cCntName="lampp"

Run()
{
    Log "$0->$FUNCNAME($*)"

    docker run \
        --name $cCntName \
        --publish 10022:22 \
        --publish 80:80 \
        --publish 3306:3306 \
        --publish 5432:5432 \
        $cImgName
        #--volume ${PWD}/mnt/mysql:/var/lib/mysql \
        #--volume ${PWD}/mnt/postgresql:/var/lib/postgresql \

}

Restore()
{
    Log "$0->$FUNCNAME($*)"

    docker start $cCntName
    docker attach $cCntName
}

Help()
{
    mysql -u admin -p -h 127.0.0.1
    psql -h localhost -U admin -d test1
    ssh admin@localhost -p 10022

    netstat -tln | grep 'tcp '

    cat /etc/hosts | grep lan
    #127.0.1.1 php74.lan php81.lan
}

docker ps -a

if [ "$(docker ps -a | grep $cImgName)" ]; then
    Restore
else
    Run
fi
