#!/bin/bash

# Created: 2024.09.10
# Author: Vladimir Vons <VladVons@gmail.com>

cImgName="vladvons/crawler"
cCntName="crawler_client_v1"

sys_ExecM()
{
    local aExec="$1"; local aMsg="$2";
    echo "$0, $FUNCNAME($*)"

    eval "$aExec"
}

_Run()
{
    echo "$0->$FUNCNAME($*)"

    echo "Image: $cImgName, container: $cCntName"

    docker run \
        --detach \
        --privileged \
        --restart unless-stopped \
        --cap-add=NET_ADMIN \
        --cap-add=SYS_MODULE \
        --name $cCntName \
        --hostname $cCntName \
        --publish 10022:22 \
        --env-file ./host.conf \
        --volume ./mnt:/mnt/host \
        --volume ./conf/wireguard:/etc/wireguard \
        $cImgName 

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
    sleep 1
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
#
sys_ExecM "docker exec -it $cCntName /bin/bash"
#docker exec -it crawler_client_v1 /bin/bash
#docker restart crawler_client_v1
#
#docker exec -it -u admin $cCntName /bin/bash
