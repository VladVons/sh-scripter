#!/bin/bash
# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

source ./install.sh


About()
{
    echo "Docker scripter. Ver $cVer. VladVons@gmail.com"
    echo "apache, php, python, mariadb, postgres, ssh"
}

InstallEnv()
{
    Log "$0->$FUNCNAME($*)"

    Msg="PKG $PKG, PKG_SSH $PKG_SSH, PKG_PHP_VER $PKG_PHP_VER, PKG_PYTHON_VER $PKG_PYTHON_VER, PKG_POSTGRES_VER $PKG_POSTGRES_VER, PKG_MARIADB $PKG_MARIADB"
    Log "$Msg"
    ColorEcho g "$Msg"

    [ "$PKG" ] && PkgInstall "$PKG"
    [ "$PKG_SSH" ] && Install_ssh
    [ "$PKG_PHP_VER" ] && Install_php "$PKG_PHP_VER"
    [ "$PKG_PYTHON_VER" ] && Install_python "$PKG_PYTHON_VER"
    [ "$PKG_POSTGRES_VER" ] && Install_postgres "$PKG_POSTGRES_VER"
    [ "$PKG_MARIADB" ] && Install_mariadb
}

Build()
{
    Log "$0->$FUNCNAME($*)"

    declare -p | grep PKG | awk '{ print $3 }'
    echo
    sleep 1

    #exit
    #Locales

    PkgUpgrade
    PkgInstall "sudo pwgen wget curl net-tools iputils-ping apt-utils"
    PkgInstall "gpg gpg-agent ca-certificates apt-transport-https"
    PkgInstall "monit postfix"

    InstallEnv
    PkgClearCache

    About
    Log "Build done"
}

Trap_CtrlC()
{
    Log "$0->$FUNCNAME($*)"

    echo "Stop ..."
    Services "" stop
    exit
}

Run()
{
    Log "$0->$FUNCNAME($*)"

    Dir=/var/www
    if [ -d  $Dir ]; then
        chown -R nobody:staff $Dir
        chmod 777 $Dir
        chmod -R g+w $Dir
    fi

    Services "" start

    ExecM "netstat -tln | grep 'tcp ' | awk '{ print \$4 }'"
    ExecM "cat /proc/meminfo | grep Mem"
    echo

    trap Trap_CtrlC SIGINT SIGTERM
    About
    echo "Running loop. Ctrl+C to break"
    while true; do
        sleep 1
    done
}


echo "--- Execute as $(whoami) ---"
case $1 in
    build|b)  Build     "$2";;
    run|r)    Run       "$2";;
esac
