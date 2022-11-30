UserConf()
{
    log_Print "$0->$FUNCNAME($*)"

    sys_ExecM "mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO '$cSuperUser'@'%' IDENTIFIED BY '${cSuperUserPassw}' WITH GRANT OPTION;\""
    sys_ExecM "mysql -u root -e \"CREATE DATABASE test1;\""
}

PostInstall()
{
    #chown -R www-data:staff /var/lib/mysql
    usermod -G staff mysql

    service mariadb restart
    sleep 1
    UserConf
}
