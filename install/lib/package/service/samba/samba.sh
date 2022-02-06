# VladVons@gmail.com

#source $cDirLib/app/samba.sh


PostInstall()
{
    Dir="/mnt/hdd/data1/share"
    mkdir -p $Dir/{public,public/image/clonezilla,recycle,temp,work,media}

    chown -R nobody:nogroup $Dir/temp
    chmod -R 777 $Dir/temp

    # register service
    Name="samba"
    #update-rc.d $Name defaults
    #systemctl enable $Name
}
