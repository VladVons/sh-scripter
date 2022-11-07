#!/bin/bash


Run_1()
{
    docker run \
        --publish 10022:22 \
        --publish 80:80 \
        --publish 3306:3306 \
        --volume ${PWD}/mnt/www:/var/www \
        vladvons/lampp1:latest
}


Run_1

#mysql -u root -p -h 127.0.0.1
#ssh admin@localhost -p 10022

#/etc/hosts: 127.0.1.1 oc2_oster.lan oc3_oster.lan
#sudo lsof -i -P -n | grep LISTEN
