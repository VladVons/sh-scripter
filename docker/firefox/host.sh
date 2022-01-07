#!/bin/bash

source ../host.sh

ImgRun()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aID=$1;

  #xhost local:$USER && \
  docker run \
    -it \
    --rm \
    --env DISPLAY \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --net=host \
    $aID
}

ImgName=$(basename $(pwd))
ImgRun $ImgName
