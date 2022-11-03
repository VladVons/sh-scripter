# VladVons@gmail.com


PostInstall()
{
    mkdir -p /var/www/webdav
    chown www-data:www-data /var/www/webdav

    # fstatic
    #touch /etc/apache2/webdav.password
    #chown www-data:www-data /etc/apache2/webdav.password
    #htdigest /etc/apache2/webdav.password webdav guest

    a2enmod dav
    a2enmod dav_fs
    a2enmod auth_digest

    apachectl configtest
    systemctl restart apache2.service
}
