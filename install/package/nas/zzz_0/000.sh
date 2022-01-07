# VladVons@gmail.com
# https://www.pestmeester.nl

source $cDirLib/app/samba.sh
source $cDirLib/app/apache.sh


AddUser()
{
    local aUser=$1; local aPassw=$2; local aHome=$3;
    Log "$0, $FUNCNAME($*)"

    DirHome=$aHome/$aUser
    mkdir -p $DirHome/backup/current

    samba_AddUser $aUser $aPassw

    apache_GenPasswFile $aUser $aPassw $DirHome/.htpasswd

    export DirHome
    cat fuser/.htaccess | envsubst > $DirHome/.htaccess

    cp fuser/user.conf $DirHome/ 

    chown -R $aUser:$aUser $DirHome
}


PostInstall()
{
    cp fuser/user.conf $cDirHome/

    AddUser guest  guest $cDirHome
    AddUser user01 pu01  $cDirHome
    #AddUser user02 pu02  $cDirHome
}
