#!/bin/bash

source ../host.sh

ImgRun()
{
    #docker network create postgres_net

    docker run \
        --detach \
        --env POSTGRES_PASSWORD=19710819 \
        --name postgres \
        --net host \
        --publish 5432:5432 \
        postgres
}

docker ps -a
echo

#ImgRun
#docker exec -it postgres bash
#psql -h localhost -U postgres
CntAttach postgres &
