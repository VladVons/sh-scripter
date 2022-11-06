#!/bin/bash


Run_1()
{
    docker run \
        --publish 80:80 \
        --publish 10022:22 \
        --volume ${PWD}/mnt/www:/var/www \
        vladvons/lampp1:latest
}

Run_1a()
{
    docker run \
    -it \
    --publish 80:80 \
    --publish 10022:22 \
    --volume ${PWD}/mnt/www:/var/www \
    vladvons/lampp1:latest \
    /bin/bash
}

Run_2()
{
    docker run \
        --publish 80:80 \
        --publish 3306:3306 \
        --publish 10022:22 \
        vladvons/lampp2:latest
}

Run_1
# sudo lsof -i -P -n | grep LISTEN
# ssh admin@localhost -p 10022
