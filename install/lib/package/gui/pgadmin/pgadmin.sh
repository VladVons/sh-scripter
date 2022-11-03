PreInstall()
{
    source /etc/os-release

    wget -qO - https://www.pgadmin.org/static/packages_pgadmin_org.pub | apt-key add
    echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$VERSION_CODENAME pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list
}


PostInstall()
{
    echo
    #/usr/pgadmin4/bin/setup-web.sh
}
