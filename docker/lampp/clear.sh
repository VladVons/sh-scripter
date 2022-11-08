#!/bin/bash

source ./script.conf

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
