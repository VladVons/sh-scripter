# VladVons@gmail.com

PostInstall()
{
    Name="vmount"

    update-rc.d $Name defaults
    systemctl enable $Name
}
