#!/bin/bash
#--- VladVons@gmail.com
# 2021.12.10


source ./pg-Tool.conf


WaitKey()
{
  local aTime=${1:-60};

  # check if script running in terminal
  if [ -t 0 ] ; then 
    echo "$0"
    read -t $aTime -p "press Enter or Ctrl-C ... ($aTime sec)"
  fi
}

Log()
{
  local aMsg="$1"; local aShow=${2:-1};

  mkdir -p $cDirLog

  Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg"
  echo "$Msg" >> $cFileLog

  if [ $aShow = 1 ]; then
     echo "$Msg"
  fi
}

CheckArgCnt()
{
  local aFunc=$1; local aCntR=$2; local aCntF=${3:-0};
  Log "$0->$aFunc"

  if [ $aCntR -ne $aCntF ]; then
    echo "$aFunc should has $aCntF args"
    exit
  fi
}

ExecM()
{
  local aExec="$1";

  echo
  #Log "$0, $FUNCNAME, $*"
  echo "--- $0, $FUNCNAME, $*"
  eval "$aExec"
}

ExecAs()
{
  local aCmd=$1;
  Log "$0, $FUNCNAME($*)" 0

  if [ "$(whoami)" == "$cPgUser" ]; then
    eval "$aCmd"
  else
    su - $cPgUser -c "$aCmd"
  fi
}

ExecSQL()
{
  local aDbName=$1; local aQuery=$2;

  ExecAs "psql -U postgres -d $aDbName -c '$aQuery'"
}

About()
{
  echo "PostgreSQL tools, ver 1.03, 2021-12-31, VladVons@gmail.com"
}

About
