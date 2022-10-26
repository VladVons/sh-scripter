#!/bin/bash

# https://hub.docker.com/r/mattrayner/lamp

source ../host.sh

ImgRun()
{
    # Launch a 18.04 based image
    docker run \
        -p "80:80" \
        -v ${PWD}/app:/app mattrayner/lamp:latest-2004
}

ImgRun
