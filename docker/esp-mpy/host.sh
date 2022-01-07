source ../host.sh


ImgRun()
{
  CheckArgCnt "$FUNCNAME($*)" $# 1
  local aID=$1;

  DUser="esp"
  Dev="/dev/ttyUSB0"

  if [ -f "$Dev" ]; then
    OptDev="--device=$Dev"
  else
    echo "device not found $Dev"
  fi

  docker run -it \
    $OptDev \
    --volume /home/$USER/PyProjects/mpy-vRelay:/home/$DUser/host \
    --user $DUser \
    --workdir=/home/$DUser \
    --name=esp-dev \
    $aID
}

ImgRun $1

