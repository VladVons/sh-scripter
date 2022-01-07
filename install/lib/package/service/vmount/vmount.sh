# VladVons@gmail.com

source $cDirLib/net.sh

PostInstall()
{
    #systemctl start vmount
    systemctl enable vmount
}
