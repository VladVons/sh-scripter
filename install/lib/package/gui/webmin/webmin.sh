# VladVons@gmail.com

PreInstall()
{
    source /etc/os-release

    File=/etc/apt/sources.list.d/webmin.list
    #echo deb http://download.webmin.com/download/repository $VERSION_CODENAME contrib  > $File
    #echo deb http://webmin.mirror.somersettechsolutions.co.uk/repository $VERSION_CODENAME contrib  >> $File
    echo deb http://download.webmin.com/download/repository sarge contrib  > $File
    echo deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib  >> $File

    wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
    #apt install webmin
}
