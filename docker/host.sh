#!/bin/bash
# VladVons@gmail.com


CheckArgCnt()
{
  local aFunc=$1; local aCntR=$2; local aCntF=${3:-0};
  echo "$0->$aFunc"

  if [ $aCntR -ne $aCntF ]; then 
    echo "$aFunc should has $aCntF args"
    exit
  fi
}

DockerInstall()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  source /etc/lsb-release
  wget -q https://download.docker.com/linux/ubuntu/gpg -O- | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $DISTRIB_CODENAME stable"
  apt update

  apt install -y apt-transport-https ca-certificates curl software-properties-common
  apt install -y docker-ce

  usermod -aG docker $USER
}

ImgCreate_1()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aDir=$1;

  #DirTmp="./tmp"
  #rm -R $DirTmp
  #mkdir -p $DirTmp
  #yes|cp -Rf /usr/lib/scripter/{install,lib} $DirTmp

  docker build -f $aDir/Dockerfile --tag $aDir .
  #rm -R $DirTmp

  docker images -a
  #docker run -it $aDir

  #Img=$(docker images -a -q | head -1)
  #docker run -it $Img
}

ImgCreate_2()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  docker search debian

  #docker run -it -v $PWD:/build --name deb10-espX-a debian:latest
  docker run -it -v $PWD:/build -name deb10-espX-a ubuntu:20.04

  docker images -a
  docker container ls -a
}

ImgCreate_3()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  apt install debootstrap

  ls /usr/share/debootstrap/scripts
  sudo debootstrap focal hello1

  sudo tar -C hello1 -c . | docker import - hello1

  docker run -it -v $PWD:/build hello1
}

ImgSave()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aImgId="$1";

  File=$(docker images -a | grep $aImgId | awk '{ print $1, $2}' | tr ' ' '_' | tr '/' '-' | tr -d '[<>]')
  if [ "$File" ]; then
    File="$File.docker.zst"
    docker save $aImgId | zstd -zv > $File
    echo "Saved to $File"
  fi
}

ImgLoad()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aFile="$1";

  zstd -dv --stdout $aFile | docker load
  docker images -a
}


ImgPull()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aName="$1";

  docker pull $aName
}


ImgRun()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aID=$1;

  docker run -it \
    --volume /home/$USER:/home/$USER \
    $aID
}

CntAttach()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aID=$1;

  docker container ls -a

  docker start $aID
  docker attach $aID
}

CntCommit()
{
  CheckArgCnt "$FUNCNAME($*)" $# 3
  local aContainerId="$1"; local aImgName=$2; local aImgTag=$3

  ### make changes in container
  #docker run -it -v $PWD:/build vladvons/$aImgName:ver1

  docker commit $aContainerId vladvons/$aImgName:$aImgTag

  docker images -a
  echo
  docker container ls -a
}

CntCopyTo()
{
  CheckArgCnt "$FUNCNAME($*)" $# 3
  local aContainerId="$1"; local aSrcOS=$2; local aDstDocker=$3

  docker cp $aSrcOS $aContainerId:$aDstDocker
}

Help()
{
  CheckArgCnt "$FUNCNAME($*)" $# 0

  echo
  echo "Syntax: $0 [options]"
  echo "attach  - restore session"
  echo "commit  - create image from container"
  echo "create1 - create image from repository + install custom packages"
  echo "create2 - create image from repository"
  echo "create3 - create image from bootstrap"
  echo "install - instal docker service"
  echo "save    - save image to file"
  echo "load    - load image from file"
}


# create1
case $1 in
    attach)    CntAttach        $2 ;;
    commit)    CntCommit        $2 $3 $4 ;;
    create1)   ImgCreate_1      $2 $3 ;;
    create2)   ImgCreate_2      ;;
    create3)   ImgCreate_3      ;;
    install)   DockerInstall    ;;
    save)      ImgSave          $2 ;;
    load)      ImgLoad          $2 ;;
    run)       ImgRun           $2;;
    help)      Help             ;;
esac
