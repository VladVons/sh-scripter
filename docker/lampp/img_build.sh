#!/bin/bash

# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lampp


source ./docker.conf

Img_Build()
{
    docker build \
        --force-rm \
        --tag $cImgName \
        --file=Dockerfile_ubuntu .

    source docker/lib/std.sh
    std_Wait
}

Img_Clear()
{
    ID=$(docker ps -a | grep $cImgName | awk '{print $1}')
    docker stop $ID
    docker rm $ID

    ID=$(docker ps -a | grep "./main" | awk '{print $1}')
    docker stop $ID
    docker rm $ID

    docker rmi $cImgName

    ID=$(docker images -a | grep "<none>" | awk '{print $3}')
    docker rmi $ID

    docker images -a

    rm ./docker/docker.log
}

Img_Push()
{
    docker login
    docker image push $cImgName
}

Cnt_Export()
{
    docker export a8b14091b4e7 > calc-container.tar
}

List()
{
    docker images -a
    echo
    docker ps -a
}

Img_Help()
{
    echo "$0 [options]"
    echo "  -b build"
    echo "  -c clear"
    echo "  -p push"
    echo "  -r run"
}

case $1 in
    build|-b)          Img_Build   "$2" ;;
    clear|-c)          Img_Clear   "$2" ;;
    push|-p)           Img_Push    "$2" ;;
    run|-r)            Img_Run     "$2" ;;
    list|-l)           List        "$2" ;;
    *)                 Img_Help    "$2" ;;
esac
