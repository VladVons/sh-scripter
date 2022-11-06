#!/bin/bash


Build_1()
{
    docker build \
        --build-arg PKG_PHP_VER="7.4" \
        --build-arg PKG="mc htop" \
        --tag vladvons/lampp1 \
        --file=Dockerfile .
}

Build_2()
{
    docker build \
        --build-arg PKG="mc htop" \
        --build-arg PKG_PHP_VER="7.4 8.0" \
        --build-arg PKG_PYTHON_VER="3.8.15 3.10.8" \
        --build-arg USER_ADMIN_PASSW="19710819" \
        --tag vladvons/lampp2 \
        --file=Dockerfile .
}

Build_1
