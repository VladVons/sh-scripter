# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

source script.conf
source ./log.sh


ExecAs()
{
    local aUser=$1; aCmd=$2;
    Log "$0, $FUNCNAME($*)"

    su - $aUser -c "$aCmd"
}

CopyFile()
{
    local aPath=$1;

    CurDir=$(pwd)
    cd $cFiles
    if [ -f "$aPath" ]; then
        cp --parents $aPath /
    else
        cp -R --parents $aPath /
    fi
    cd $CurDir
}

LogClear()
{
    Log "$0->$FUNCNAME($*)"

    local DirLog=/var/log
    local FExt="gz|xz|tmp|[1-9]"
    find $DirLog -type f -regextype posix-extended -iregex ".*\.($FExt)" -delete

    FExt="log|err|info|warn|txt"
    local FName="messages|syslog"
    find $DirLog -type f -regextype posix-extended -iregex "(.*\.($FExt)|.*($FName))" | xargs -I {} truncate -s 0 {}
}

Locales()
{
  Log "$0, $FUNCNAME($*)"

  locale-gen ${cLocale} ${cLocale}.UTF-8
  #update-locale LC_ALL=${cLocale}.UTF-8 LANG=${cLocale}.UTF-8
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  cat /etc/timezone | xargs timedatectl set-timezone
}

PkgInstall()
{
    local aPkg=$1;
    Log "$0->$FUNCNAME($*)"

    ColorEcho g "$0->$FUNCNAME($*)"
    ExecM "apt-get install --yes --no-install-recommends $aPkg"
}

PkgClearCache()
{
    Log "$0->$FUNCNAME($*)"

    ExecM "apt-get --yes autoremove"
    ExecM "apt-get --yes clean"
}

PkgUpgrade()
{
    ExecM "apt-get update"
    ExecM "apt-get --yes upgrade"
}

UserAdd()
{
    Log "$0->$FUNCNAME($*)"
    local aUser=$1; aPassw=$2;

    local Home=/home/$aUser

    gPASS=${aPassw:-$(pwgen -s 8 1)}
    ExecM "useradd $aUser --groups sudo --home-dir $Home --create-home --shell /bin/bash"
    echo -e "$gPASS\n$gPASS\n" | passwd $aUser
    echo "Added user: $aUser, passw: $gPASS"
}

Services()
{
    local aServices="$1"; aMode="$2";
    Log "$0->$FUNCNAME($*)"

    if [ -z "$aServices" ]; then
        aServices=$(ls $cDirInit)
    fi

    for Service in $aServices; do
        File=$cDirInit/$Service
        if [ -f "$File" ]; then
            ExecM "$File $aMode"
            #sleep 0.5
            #service $Service $aMode
            #sleep 0.5
            #$File status
            #ps aux | grep $Service | grep -v grep
        else
            echo "Err: File not exists $File"
        fi
    done
}
