# VladVons@gmail.com

source $cDirLib/net.sh

PostInstall()
{
    usermod -a -G lpadmin pi
    service cups restart
    echo "cups server url is https://$(Net_GetLocalIp):631"
}
