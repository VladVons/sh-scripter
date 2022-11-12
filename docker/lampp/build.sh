#!/bin/bash

# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lampp


source ./docker.conf

Build_1()
{
    docker build \
        --force-rm \
        --tag $cImgName \
        --file=Dockerfile_ubuntu .
}

Push()
{
    docker image push $cImgName
}

Build_1
#
#Push
