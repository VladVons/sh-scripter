# VladVons@gmail.com

PreInstall()
{
    Ver="18"

    File="setup_$Ver.x"
    wget https://raw.githubusercontent.com/nodesource/distributions/master/deb/$File
    bash $File
    rm $File
}
