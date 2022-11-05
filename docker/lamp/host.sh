#!/bin/bash

source ../host.sh


#https://github.com/mattrayner/docker-lamp
#https://github.com/mattrayner/docker-lamp/blob/master/2004/Dockerfile


_ImgPull()
{
    docker pull mattrayner/lamp:latest
}

ImgRun()
{
    docker run \
        --name web_lamp \
        --publish 80:80 \
        --publish 3306:3306 \
        --volume ${PWD}/app:/app \
        --volume ${PWD}/mysql:/var/lib/mysql \
        mattrayner/lamp:latest
}

#ImgRun

##remove folder 'mysql' to reinit DB and reset password
#mysql -u admin -pueGZGjaIb4hk -h 127.0.0.1

#docker exec web_lamp mysql -u root -e "create database DATABASE_NAME;"
