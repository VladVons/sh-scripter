# VladVons@gmail.com

PostInstall()
{
    Name="x11vnc"

    update-rc.d $Name defaults
    systemctl enable $Name
}
