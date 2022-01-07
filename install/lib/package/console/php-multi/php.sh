# VladVons@gmail.com

PreInstall()
{
  apt install wget ca-certificates apt-transport-https gnupg
  wget -q https://packages.sury.org/php/apt.gpg -O- | sudo apt-key add -

  echo "deb https://packages.sury.org/php/ buster main" | tee /etc/apt/sources.list.d/php.list
  apt update
}


PostInstall()
{
  update-alternatives --set php /usr/bin/php7.4
  php -i | grep "Loaded Configuration File"

  a2dismod php5.6
  a2enmod php7.4

  a2enmod actions fcgid alias proxy_fcgi
  service apache2 restart
}
