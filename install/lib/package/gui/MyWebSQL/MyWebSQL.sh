# VladVons@gmail.com


PostInstall()
{
    source $cDirLib/arch.sh

    Dir="/var/www/app"
    Arch_UnzipUrl "https://github.com/Samnan/MyWebSQL/archive/master.zip" $Dir
    mv $Dir/MyWebSQL-master $Dir/MyWebSQL
    chown -R www-data $Dir/MyWebSQL
}
