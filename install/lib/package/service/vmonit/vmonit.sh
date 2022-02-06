# VladVons@gmail.com


PostInstall()
{
    Name="vmonit"

    update-rc.d $Name defaults
    systemctl enable $Name
}
