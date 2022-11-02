CreateDb()
{
    echo "$FUNCNAME($*)"

    Db='app_nextcloud'
    DbUser='nextcloud'
    DbPassw='nc13579'

    mysql -u root -e "\
        CREATE DATABASE IF NOT EXISTS $Db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;\
        GRANT ALL PRIVILEGES ON $Db.* TO $DbUser@localhost IDENTIFIED BY '${DbPassw}';\
        FLUSH PRIVILEGES;\
    "
}

Download()
{
    echo "$FUNCNAME($*)"

    File='nextcloud.zip'
    wget https://download.nextcloud.com/server/releases/nextcloud-25.0.0.zip -O $File

    Dir='/var/www/enabled'
    unzip $File -d $Dir
    chown -R www-data $Dir
}

Apache()
{
    echo "$FUNCNAME($*)"

    a2enmod php
    a2enmod rewrite
    a2enmod headers
    a2enmod env
    a2enmod dir
    a2enmod mime

    a2enmod ssl
    a2ensite default-ssl

    systemctl restart apache2
}

PostInstall()
{
    Download
    Apache
    CreateDb
}
