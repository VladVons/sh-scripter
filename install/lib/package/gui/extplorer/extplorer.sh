# VladVons@gmail.com


PostInstall()
{
    source $cDirLib/arch.sh

    Dir="/var/www/app/eXtplorer"
    Arch_UnzipUrl "https://extplorer.net/attachments/download/82/eXtplorer_2.1.13.zip" $Dir
    chown -R www-data $Dir
}
