#!/bin/bash

source ./script.conf

Build_1()
{
    docker build \
        --build-arg SUPERUSER="admin" \
        --build-arg SUPERUSER_PASSW="19710819" \
        --build-arg PKG_SSH=YES \
        --build-arg PKG_PHP_VER="7.4 8.1" \
        --build-arg PKG_POSTGRES_VER="9.4" \
        --build-arg PKG_MARIADB=YES \
        --build-arg PKG="mc htop" \
        --tag $cImgName \
        --file=Dockerfile .
}

Build_2()
{
    docker build \
        --build-arg SUPERUSER="admin" \
        --build-arg SUPERUSER_PASSW="19710819" \
        --build-arg PKG_PHP_VER="7.4" \
        --build-arg PKG_MARIADB=YES \
        --tag $cImgName \
        --file=Dockerfile .
}


Build_1
#Build_2