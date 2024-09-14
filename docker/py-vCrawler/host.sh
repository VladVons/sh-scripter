#!/bin/bash

# Created: 2024.09.10
# Author: Vladimir Vons <VladVons@gmail.com>

cImgName="vladvons/crawler"
cCntName="crawler_client_v1"

_Run()
{
    echo "$0->$FUNCNAME($*)"

    echo "Image: $cImgName, container: $cCntName"

    docker run \
        --restart unless-stopped \
        --name $cCntName \
        --hostname $cCntName \
        --publish 10022:22 \
        --env-file ./host.conf \
        --volume ${PWD}/mnt:/mnt/host \
        $cImgName 
        #--detach \

}

_Restore()
{
    echo "$0->$FUNCNAME($*)"

    docker start $cCntName
    echo "container $cCntName started"
    #docker attach $cCntName
}

Stop() 
{
    docker stop $cCntName
    docker rm $cCntName
    docker ps -a
}

Run()
{
    echo "$0->$FUNCNAME($*)"

    #rm /home/vladvons/.ssh/known_hosts

    docker ps -a
    if [ "$(docker ps -a | grep $cImgName)" ]; then
        _Restore
    else
        _Run
    fi
}


#Stop
Run
docker exec -it $cCntName /bin/bash
