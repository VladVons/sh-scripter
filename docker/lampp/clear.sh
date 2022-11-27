#!/bin/bash
# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lampp


source ./docker.conf

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
