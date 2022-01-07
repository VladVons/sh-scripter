#!/bin/bash

source ../host.sh


ImgRun()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  docker run \
    --rm \
    -e UID=$(id -u) \
    -e GID=$(id -g) \
    --workdir /project \
    -v "$PWD":/project \
    matspfeiffer/flutter 
}

ImgRun2()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  #sudo apt install qemu-kvm
  #sudo groupadd -r kvm
  #sudo gpasswd -a $USER kvm

  xhost local:$USER && \
  docker run \
    --rm -ti \
    -e UID=$(id -u) \
    -e GID=$(id -g) \
    -p 42000:42000 \
    --workdir /project \
    --device /dev/kvm \
    --device /dev/dri:/dev/dri \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY \
    -v "$PWD":/project \
    --entrypoint flutter-android-emulator \
    matspfeiffer/flutter
}

# https://docs.flutter.dev/development/tools/sdk/releases

ImgRun
#ImgRun2
