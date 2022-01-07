#!/bin/bash

source ../host.sh

ImgRun()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  docker run -d \
     -p 8080:8080 \
     -v /etc/localtime:/etc/localtime:ro \
     -v /etc/timezone:/etc/timezone:ro \
     -v $HOME/Shinobi/config:/config \
     -v $HOME/Shinobi/datadir:/var/lib/mysql \
     -v $HOME/Shinobi/videos:/opt/shinobi/videos \
     -v /dev/shm/shinobiDockerTemp:/dev/shm/streams \
     migoller/shinobidocker
}

#ImgPull migoller/shinobidocker

#ImgName=$(basename $(pwd))
ImgRun
