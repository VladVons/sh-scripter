#!/bin/bash

# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>
# https://hub.docker.com/repository/docker/vladvons/lamp2

source ./docker.conf


_Run()
{
    echo "$0->$FUNCNAME($*)"

    echo "Image: $cImgName, container: $cCntName"
    docker run \
        --restart unless-stopped \
        --name $cCntName \
        --hostname $cCntName \
        --publish 10022:22 \
        $cImgName
        #--publish 80:80 \
        #--publish 3306:3306 \
        #--publish 5432:5432 \
        #--volume ${PWD}/mnt/www:/var/www \
        #--volume ${PWD}/mnt/mysql:/var/lib/mysql \
        #--volume ${PWD}/mnt/postgresql:/var/lib/postgresql \
}

_Restore()
{
    echo "$0->$FUNCNAME($*)"

    docker start $cCntName
    echo "container $cCntName started"
    #docker attach $cCntName
}

Export()
{
    File=$cCntName.zst
    echo "Export file $File ..."
    #docker export $cCntName > $cCntName.dat
    docker export $cCntName | zstd -zv > $File
}

Import()
{
    echo "$0->$FUNCNAME($*)"

    File=$cCntName.zst
    echo "Import file $File ..."
    #docker import $File $cCntName.dat
    zstd -dv --stdout $File | \
        docker import - $cCntName \
            --change "WORKDIR /root/docker" \
            --change "CMD [\"./docker_run.sh\"]"
    docker images -a
}

Run()
{
    echo "$0->$FUNCNAME($*)"

    rm /home/vladvons/.ssh/known_hosts

    docker ps -a
    if [ "$(docker ps -a | grep $cImgName)" ]; then
        _Restore
    else
        _Run
    fi
}

Bash()
{
    docker exec -it $cCntName bash
}


Save()
{

    docker ps
    docker stop $cCntName
    docker commit $cCntName $cImgName
    docker rm $cCntName
    #docker run NEW_SETTINGS --name $cCntName $cImgName
}

RemapPorts()
{
    docker stop $cCntName
    service docker stop
    mcedit $(grep -HR $cCntName /var/lib/docker/containers/*/hostname | cut -d: -f1 | xargs dirname)/hostconfig.json
    service docker start
    docker start $cCntName
}

Help()
{
    echo "$0->$FUNCNAME($*)"

    ssh admin@localhost -p 10022

    mysql -u admin -p -h 127.0.0.1
    mysql -u admin -p -h 127.0.0.1 -e "CREATE DATABASE test2;"

    psql -h localhost -U admin -d test1
    psql -h localhost -U admin -d template1 -c "CREATE DATABASE test2;"

    netstat -tln | grep 'tcp '

    sudo echo "127.0.0.1 php74.lan php81.lan" >> /etc/hosts
}

case $1 in
    -r)    Run      "$2" ;;
    -e)    Export   "$2" ;;
    -i)    Import   "$2" ;;
    -s)    Save     "$2" ;;
    -b)    Bash     "$2" ;;
    *)     Run      "$2" ;;
esac
