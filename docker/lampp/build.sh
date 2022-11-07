#!/bin/bash


Build_1()
{
    docker build \
        --build-arg PKG_PHP_VER="7.4 8.0" \
        --build-arg PKG_MARIADB=YES \
        --build-arg PKG="mc htop" \
        --build-arg USER_ADMIN_PASSW="19710819" \
        --tag vladvons/lampp1 \
        --file=Dockerfile .
}

Build_1
