# VladVons@gmail.com

PostInstall()
{
    Dir=$(pwd)
    runuser -l $cUser -c "$Dir/AsUser.sh"

    Name="vvncserver"
    update-rc.d $Name defaults
    systemctl enable $Name
}
