# VladVons@gmail.com

source $cDirLib/net.sh

PostInstall()
{
    update-rc.d vmonit defaults
    systemctl enable vmonit
}
