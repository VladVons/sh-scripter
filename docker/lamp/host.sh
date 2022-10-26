#!/bin/bash

# https://hub.docker.com/r/mattrayner/lamp

source ../host.sh

ImgRun()
{
    # Launch a 18.04 based image
    docker run \
        -p "80:80" \
        -v ${PWD}/app:/app mattrayner/lamp:latest-2004
}

#ImgRun

#ID=14af978afb36
#docker exec CONTAINER_ID  mysql -uroot -e "create database DATABASE_NAME"
#docker exec $ID mysql -uroot -e "show databases;"
