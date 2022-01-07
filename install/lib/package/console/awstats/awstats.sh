# VladVons@gmail.com


PostInstall()
{
    a2enmod cgi
    systemctl restart apache2.service

    perl -MCPAN -e "install Geo::IP"
}
