#!/bin/bash

source ../host.sh

ImgRun()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aID=$1;

  docker run -it \
    $aID
}

Build()
{
  docker build -t android-build:android-gradle .
}


#ImgName=$(basename $(pwd))
#ImgRun $ImgName

Build
