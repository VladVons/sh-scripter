#!/bin/bash

# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lampp


source ./docker.conf

Build_1()
{
    docker build \
        --build-arg SUPERUSER="admin" \
        --build-arg SUPERUSER_PASSW="admin" \
        --build-arg PKG_SSH=YES \
        --build-arg PKG_PHP_VER="5.6 7.4 8.1" \
        --build-arg PKG_PYTHON_VER="3.10" \
        --build-arg PKG_POSTGRES_VER="9.4" \
        --build-arg PKG_MARIADB=YES \
        --build-arg PKG="mc htop" \
        --tag $cImgName \
        --file=Dockerfile-ubuntu .
}

Build_2()
{
    docker build \
        --build-arg SUPERUSER="admin" \
        --build-arg SUPERUSER_PASSW="admin" \
        --build-arg PKG_PHP_VER="7.4" \
        --build-arg PKG_MARIADB=YES \
        --tag $cImgName \
        --file=Dockerfile-debian .
}


Push()
{
    docker image push $cImgName
}

#Build_1
#Build_2
#
Push
