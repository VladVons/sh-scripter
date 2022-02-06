# VladVons@gmail.com


PostInstall()
{
    Name="vwol"

    update-rc.d $Name defaults
    systemctl enable $Name
}
