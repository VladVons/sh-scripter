#!/bin/bash
#--- VladVons@gmail/com 
# created 22.01.2020
# version 1.02


DoExcl()
{
  _Excl=$Excl
  for Ext in $(echo $ExclExt | tr "," "\n"); do
    _Excl="$_Excl --exclude=*.$Ext"
  done

  Excl=""
  ExclExt=""
}


Backup()
{
    _Prefix=$(hostname)_${Prefix}
    DOW=$(date '+%u')

    PWD=$(pwd)
    temp=$(dirname $(mktemp -u))
    cd $temp
    rm -rf ${_Prefix}
    mkdir -p ${_Prefix}

    # create remote directory trick 
    rsync --archive ${_Prefix} $User@$Host::${Section}

    # clear remote directory trick
    rsync --delete --archive ${_Prefix}/ $User@$Host::${Section}/${_Prefix}/${DOW}

    # make file list 
    find $SrcDir > ${_Prefix}/.RsyncWeek.lst
    cp ${_Prefix}/.RsyncWeek.lst $SrcDir
    rsync --archive ${_Prefix}/ $User@$Host::${Section}/${_Prefix}/${DOW}

    # get _Excl
    DoExcl
    echo _Excl ${_Excl}

    cd $SrcDir
    Options="--verbose --progress --force --ignore-errors --archive --recursive --delete --backup --backup-dir=/${_Prefix}/${DOW} ${_Excl}"
    rsync $Options . $User@$Host::${Section}/${_Prefix}/current

    cd $PWD
}


Restore()
{
    DOW="3"

    Options="--verbose --progress --archive"
    #rsync $Options $User@$Host::${Section}${_Prefix}/current $SrcDir
    rsync $Options $User@$Host::${Section}${_Prefix}/current/doc /admin/conf
    #rsync $Options $User@$Host::${Section}${_Prefix}/${DOW}/  $SrcDir
}
