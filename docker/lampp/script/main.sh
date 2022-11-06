#!/bin/bash

source ./log.sh

cFiles="files"


copy_file()
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

install_pkg()
{
    local aPkg=$1;
    Log "$0->$FUNCNAME($*)"

    ColorEcho g "install $aPkg"
    ExecM "apt-get install --yes --no-install-recommends $aPkg"
} 

install_apache2()
{
    Log "$0->$FUNCNAME($*)"

    install_pkg "apache2 apache2-utils libapache2-mod-fcgid"
    copy_file etc/monit/conf-enabled/apache2
    copy_file etc/apache2

    a2enmod rewrite
    a2enmod actions fcgid alias proxy_fcgi

    usermod -G staff www-data
    chmod 777 /var/www
}

install_php()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"

    install_apache2

    ExecM "wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg"
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
    ExecM "apt update"

    for Ver in $aVer; do
        install_pkg "php${Ver} libapache2-mod-php${Ver} php${Ver}-fpm"
    done
}

install_compile_python()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"

    install_pkg "python3-setuptools python3-pip"
    install_pkg "build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev"

    for Ver in $aVer; do
        File="Python-${Ver}.tgz"
        ExecM "wget https://www.python.org/ftp/python/$Ver/$File"

        ExecM "tar -xvf $File"

        FileName="${File%.*}"
        cd "$FileName"
        ExecM "./configure --enable-optimizations"
        ExecM "make & make altinstall"
        cd ..

        rm $File
        rm -R $FileName
    done
}

install_python_()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"

    install_pkg "python3-pip"
    install_pkg "software-properties-common gpg gpg-agent dirmngr"
    ExecM "add-apt-repository ppa:deadsnakes/ppa"
    ExecM "apt update"

    for Ver in $aVer; do
        install_pkg "python${Ver}"
    done
}

install_env()
{
    Log "$0->$FUNCNAME($*)"

    if [ "$PKG" ]; then
        install_pkg "$PKG"
    fi

    if [ "$PKG_PHP_VER" ]; then
        ColorEcho g "$PKG_PHP_VER"
        install_php "$PKG_PHP_VER"
    fi

    if [ "$PKG_PYTHON_VER" ]; then
        ColorEcho g "$PKG_PYTHON_VER"
        install_compile_python "$PKG_PYTHON_VER"
    fi
}

clear_apt()
{
    Log "$0->$FUNCNAME($*)"

    ExecM "apt-get --yes autoremove"
    ExecM "apt-get --yes clean"
}

user_add()
{
    Log "$0->$FUNCNAME($*)"
    local aUser=$1; aPassw=$2;

    local Home=/home/$aUser

    PASS=${aPassw:-$(pwgen -s 8 1)}
    ExecM "useradd $aUser --groups sudo --home-dir $Home --create-home"
    echo -e "$PASS\n$PASS\n" | passwd $aUser
    echo "Added user: $aUser, passw: $PASS"
    #copy_file etc/monit/conf-enabled/ssh
}

services()
{
    local aServices="$1"; aMode="$2";
    Log "$0->$FUNCNAME($*)"

    DirInit="/etc/init.d"
    if [ -z "$aServices" ]; then
        aServices=$(ls $DirInit)
    fi

    for Service in $aServices; do
        File=$DirInit/$Service
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

build()
{
    Log "$0->$FUNCNAME($*)"

    ExecM "apt-get update"
    #ExecM "apt-get --yes upgrade"

    install_pkg "sudo pwgen"
    install_pkg "ssh monit"
    install_pkg "gpg ca-certificates apt-transport-https lsb-release"
    install_pkg "wget postfix"
    install_pkg "lsof"

    install_env
    clear_apt
    user_add admin 19710819

    #mkdir -p /app
    #    rm -fr /var/www/html; \
    #    ln -s /app /var/www/html;


}

trap_ctrl_c()
{
    Log "$0->$FUNCNAME($*)"

    echo "Stop ..."
    services "" stop
    exit
}

run()
{

    echo "--- run as $(whoami)"
    echo "ROOT_PASSW: $ROOT_PASSW"

    services "" start

    #mkdir -p /app/data
    #ln -s /etc /app/data/etc 

    #mount --bind /var/www /app/data/www
    #mount --bind /etc /app/data/etc

    Dir=/var/www
    chown -R :staff $Dir
    chmod 777 $Dir
    chmod -R g+w $Dir

    ExecM "lsof -i -P -n | grep LISTEN"

    trap trap_ctrl_c SIGINT SIGTERM
    echo "Running ..."
    while true; do
        sleep 1
    done
}


#copy_file etc/monit/conf-enabled/apache2

case $1 in
    build|b)  build     "$2";;
    run|r)    run       "$2";;
esac
