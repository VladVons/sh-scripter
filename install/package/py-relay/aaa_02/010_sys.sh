# VladVons@gmail.com

PythonLib()
{
    pip3 install wheel
    pip3 install setuptools
    pip3 install nuitka

    pip3 install aiohttp
    pip3 install yattag
    pip3 install apcaccess
}


PreInstall()
{
    mkdir -p /mnt/{smb/temp,usb}

    dpkg-reconfigure locales
    Pkg_Update
}


PostInstall()
{
    PythonLib

    usermod -a -G i2c pi

    mkdir -p /var/log/py-relay
    chmod -R /var/log/py-relay 755
}
