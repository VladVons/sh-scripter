PostInstall()
{
    a2enmod rewrite
    a2enmod actions fcgid alias proxy_fcgi ssl

    usermod -G staff www-data
    chmod 777 /var/www

    # ssl for https
    mkdir /etc/apache2/certificate
    cd /etc/apache2/certificate
    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key
}
