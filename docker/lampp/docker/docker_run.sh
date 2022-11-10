#!/bin/bash
# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

source ./install.sh

IsShowUserAuth=0
SUPERUSER=${SUPERUSER:-"admin"}
SUPERUSER_PASSW=${SUPERUSER_PASSW:-$(pwgen -s 8 1)}


ShowUserAuth()
{
    if [ $IsShowUserAuth == 0 ]; then
        return
    fi
 
cat << EOM
---------------------------
user: $SUPERUSER
password: $SUPERUSER_PASSW
---------------------------

EOM
}

Init_apache2()
{
    Log "$0->$FUNCNAME($*)"

    Dir="/var/www"
    if [ -d  $Dir ]; then
        chown -R nobody:staff $Dir
        chmod 777 $Dir
        chmod -R g+w $Dir
    fi
}

Init_mariadb()
{
    Log "$0->$FUNCNAME($*)"

    Dir="/var/lib/mysql"
    if [ ! -d $Dir/mysql ]; then
        echo "Ininitialize mariadb volume $Dir ..."
        mysql_install_db
        chown -R mysql:staff $Dir

        $cDirInit/mariadb start
        sleep 1
        User_mariadb
        #ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('root');

        IsShowUserAuth=1
    fi
}

Init_postgresql()
{
    Log "$0->$FUNCNAME($*)"

    Pkgs=$(dpkg -l | grep postgres | grep server | awk '{ print $2 }')
    DirApp=/var/lib/postgresql
    for Pkg in $Pkgs; do
        SubDir=${Pkg/-/\/}
        Dir="/var/lib/$SubDir/main"
        if [ ! -d  $Dir ]; then
            echo "Ininitialize postgres volume $Dir ..."

            chown postgres:staff $DirApp
            PgBin="/usr/lib/$SubDir/bin"
            #ExecAs postgres "$PgBin/initdb -D $Dir --locale=$cLocale.UTF-8 --lc-collate=$cLocale.UTF-8 --lc-ctype=$cLocale.UTF-8 --encoding=UTF8"
            ExecAs postgres "$PgBin/initdb -D $Dir --encoding=UTF8"

            $cDirInit/postgresql start
            sleep 1
            User_postgres $PgBin
            #chown postgres:staff $DirApp

            IsShowUserAuth=1
        fi
    done
}

Init()
{
    Log "$0->$FUNCNAME($*)"

    Services="apache2 mariadb postgresql"
    for Service in $Services; do
        if [ -f "$cDirInit/$Service" ]; then
            Init_$Service
        fi
    done
}

Trap_CtrlC()
{
    Log "$0->$FUNCNAME($*)"

    echo "Stop ..."
    ServicesExec "" stop
    exit
}

Run()
{
    Log "$0->$FUNCNAME($*)"

    Init
    ServicesExec "" start

    ExecM "netstat -tln | grep 'tcp ' | awk '{ print \$4 }'"
    ExecM "cat /proc/meminfo | grep Mem"
    echo

    trap Trap_CtrlC SIGINT SIGTERM
    ShowUserAuth
    About
    echo "Running loop. Ctrl+C to break"
    while true; do
        sleep 1
    done
}

Run
