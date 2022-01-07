# VladVons@gmail.com


PostInstall()
{
    a2enmod rewrite
    a2enmod headers
    a2enmod ssl
    a2ensite default-ssl

    systemctl restart apache2.service
}
