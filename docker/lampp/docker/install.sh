# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

source ./common.sh
source ./repo.sh
source ./repo-${ID}.sh


User_postgres()
{
    local aPgBin=$1;
    Log "$0->$FUNCNAME($*)"

    ExecAs postgres "$aPgBin/psql -U postgres -d template1 -c \"CREATE USER $SUPERUSER WITH SUPERUSER PASSWORD '$SUPERUSER_PASSW';\""
    ExecAs postgres "$aPgBin/psql -U postgres -d template1 -c \"CREATE DATABASE test1;\""
    ExecAs postgres "$aPgBin/psql -l -U postgres"
}

Install_postgres()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    repo_postgres

    PkgInstall "postgresql-common"
    for Ver in $aVer; do
        PkgInstall "postgresql-${Ver} postgresql-contrib-${Ver}"
        $cDirInit/postgresql start
        sleep 0.5
        #pg_createcluster --start $Ver main

        PgBin="/usr/lib/postgresql/$Ver/bin"
        User_postgres $PgBin

        CopyFile etc/monit/conf-enabled/postgres_$Ver
        CopyFile etc/postgresql/$Ver
    done
    #usermod -G staff postgres
}

User_mariadb()
{
    Log "$0->$FUNCNAME($*)"

    ExecM "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO '$SUPERUSER'@'%' IDENTIFIED BY '${SUPERUSER_PASSW}' WITH GRANT OPTION;\""
    ExecM "mysql -u root -e \"CREATE DATABASE test1;\""
}

Install_mariadb()
{
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    PkgInstall "mariadb-server"

    CopyFile etc/mysql
    CopyFile etc/monit/conf-enabled/mariadb

    #chown -R www-data:staff /var/lib/mysql
    usermod -G staff mysql

    service mariadb restart
    sleep 1
    User_mariadb

}

Install_extplorer()
{
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    Dir="/usr/lib/eXtplorer"
    File="temp.zip"
    Url="https://extplorer.net/attachments/download/99/eXtplorer_2.1.15.zip"

    ExecM "wget --quiet --output-document=$File $Url"
    ExecM "unzip -q -d $Dir $File && rm $File"
    chown -R www-data $Dir
}

Install_phpMyAdmin()
{
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    Dir="/usr/lib"
    File="temp.zip"
    Url="https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip"

    ExecM "wget --quiet --output-document=$File $Url"
    ExecM "unzip -q $File && rm $File"
    mv $(ls | grep phpMyAdmin) $Dir/phpMyAdmin
    chown -R www-data $Dir/phpMyAdmin
}

Install_apache2()
{
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    PkgInstall "apache2 apache2-utils libapache2-mod-fcgid"
    CopyFile etc/monit/conf-enabled/apache2
    CopyFile etc/apache2

    a2enmod rewrite
    a2enmod actions fcgid alias proxy_fcgi

    usermod -G staff www-data
    chmod 777 /var/www
}

Install_php()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    CopyFile var/www
    Install_apache2

    repo_php

    for Ver in $aVer; do
        PkgInstall "php${Ver} libapache2-mod-php${Ver} php${Ver}-fpm"
        PkgInstall "php${Ver}-xml php${Ver}-mbstring php${Ver}-soap php${Ver}-gd php${Ver}-zip php${Ver}-mysql php${Ver}-pgsql"
        PkgInstall "php${Ver}-mcrypt"
    done

    Install_phpMyAdmin
    Install_extplorer
}

Install_compile_python()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    PkgInstall "python3-setuptools python3-pip"
    PkgInstall "wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev"

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

Install_python()
{
    local aVer=$1;
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    repo_python

    PkgInstall "gcc libpq-dev libffi-dev"
    PkgInstall "python3-pip python3-setuptools"
    for Ver in $aVer; do
        PkgInstall "python${Ver} python${Ver}-dev python${Ver}-venv"
    done
}

Install_ssh()
{
    Log "$0->$FUNCNAME($*)"
    ColorEcho g "$0->$FUNCNAME($*)"

    PkgInstall "ssh"
    UserAdd $SUPERUSER $SUPERUSER_PASSW
    CopyFile etc/monit/conf-enabled/ssh
}
