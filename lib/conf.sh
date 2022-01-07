# VladVons@gmail.com

cAppConfDir=/etc/scripter

if [ -z "$cAppDir" ]; then
  cAppDir=$(pwd)
fi

if [ -z "$cAppName" ]; then 
    cAppName=$0
fi
cAppName=$(basename $cAppName)


Conf_Include()
{
  local aFile=$1;

  if [ -r $aFile ]; then
    source $aFile 
    echo "conf:$aFile"
  fi
}


Conf_Log()
{
    local BaseDir=$(basename $cAppDir)
    local DirLog=/var/log/scripter/$BaseDir

    [ -d $DirLog ] || mkdir -p $DirLog


    cFileLog=$DirLog/$cAppName.log
    echo "log:$cFileLog"
}


Conf_Options()
{
    local BaseDir=$(basename $cAppDir)

    Conf_Include $cAppConfDir/common.conf
    Conf_Include $cAppConfDir/$BaseDir/common.conf
    Conf_Include $cAppConfDir/$BaseDir/$cAppName.conf
    Conf_Include $cAppName.conf

    cAppDefault=$cAppConfDir/$BaseDir/$cAppName
}

Conf_Log
Conf_Options
