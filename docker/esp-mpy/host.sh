#source ../host.sh


ImgRun()
{
  #CheckArgCnt "$FUNCNAME($*)" $# 1
  local aID=$1;

  DUser="esp"
  #DUser="root"
  Dev="/dev/ttyUSB0"

  if [ -r "$Dev" ]; then
    OptDev="--device=$Dev"
    echo "$Dev ok"
  else
    echo "$Dev err"
  fi

  docker run -it \
    $OptDev \
    --volume /home/$USER/Projects/py/mpy-vRelay:/home/$DUser/host \
    --user root \
    --workdir=/home/$DUser \
    --name=$aID \
    $aID
}


ImgName=$(basename $(pwd))
CntName=$(docker container ls -a | grep esp-mpy | awk '{print $1}')
if [ -z "$CntName" ]; then
  ImgRun $ImgName
else
  echo "attach container $CntName"
  cd $(dirname $0)
  docker start $CntName
  docker attach $CntName
fi
