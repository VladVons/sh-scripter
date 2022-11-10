#!/bin/bash
# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

source ./install.sh


InstallEnv()
{
    Log "$0->$FUNCNAME($*)"

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

    declare -p | grep PKG
    sleep 1

    #exit
    #Locales

    PkgUpgrade
    PkgInstall "sudo pwgen wget curl net-tools iputils-ping apt-utils zip unzip"
    PkgInstall "gpg gpg-agent ca-certificates apt-transport-https"
    PkgInstall "monit postfix"

    InstallEnv
    PkgClearCache

    About
    Log "Build done"
}

time Build
