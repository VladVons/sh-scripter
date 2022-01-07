# VladVons@gmail.com

MCrypt()
{
    apt install --no-install-recommends php-dev php-pear libmcrypt-dev make
    pecl channel-update pecl.php.net
    #pecl search mcrypt
    #pecl uninstall mcrypt
    pecl install mcrypt
    #echo "extension=mcrypt.so" > /etc/php/7.4/apache2/conf.d/mcrypt.ini
}


PostInstall()
{
    #MCrypt

    systemctl restart apache2.service
}
