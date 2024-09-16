#!/bin/bash

# Created: 2024.09.10
# Author: Vladimir Vons <VladVons@gmail.com>

cImgName="vladvons/crawler_client:v1"

CntName="crawler_client"
CntVer="v1"
cCntName="${CntName}_${CntVer}"


sys_ExecM()
{
    local aExec="$1"; local aMsg="$2";
    echo "$0, $FUNCNAME($*)"

    eval "$aExec"
}

Run()
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
        --volume ./conf/vMonit:/root/projects/vMonit/Conf/Default \
        $cImgName 

}

Img_Save()
{
    Dir="./img"
    mkdir -p $Dir

    File=$(echo $cImgName | tr '/' '-')
    File="./img/$File.docker.zst"

    docker save $cImgName | zstd -zv > $File
    echo "Saved to $File"
}

Img_Load()
{
  local aFile="$1";

  zstd -dv --stdout $aFile | docker load
  docker images -a
}

Commit()
{
  Ver=$(echo $CntVer | grep -o '[0-9]\+')
  VerNext=$((Ver + 1))
  VerNew=$(echo $CntVer | sed "s/[0-9]\+/$VerNext/")

  CntNameNew="${CntName}_${VerNew}"
  echo "$cCntName -> $CntNameNew"

  #docker commit $cCntName $CntNameNew
  docker images -a | grep $CntName

  docker stop $cCntName
  #docker rm $cCntName
}

Restore()
{
    echo "$0->$FUNCNAME($*)"

    docker start $cCntName
    echo "container $cCntName started"
    #docker attach $cCntName
}

Remove() 
{
    docker stop $cCntName
    docker rm $cCntName
    docker ps -a

    sleep 1
}

Exec()
{
    echo "$0->$FUNCNAME($*)"

    #rm /home/vladvons/.ssh/known_hosts

    docker ps -a
    if [ "$(docker ps -a | grep $cImgName)" ]; then
        Restore
    else
        Run
    fi
}


#Img_Save
#Img_Load img/vladvons-crawler_client:v1.docker.zst
#
#Remove
Exec
#Commit
#
#sys_ExecM "docker exec -it $cCntName /bin/bash"
#docker exec -it crawler_client_v1 /bin/bash
#docker restart crawler_client_v1
#
#docker exec -it -u admin $cCntName /bin/bash
