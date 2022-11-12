PostInstall()
{
    a2enmod rewrite
    a2enmod actions fcgid alias proxy_fcgi

    usermod -G staff www-data
    chmod 777 /var/www
}
