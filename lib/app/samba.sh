# VladVons@gmail.com


samba_AddUser()
{
    local aUser=$1; local aPassw=$2;
    Log "$0->$FUNCNAME($*)"

    User_AddNoLogin $aUser $aPassw $cDirHome
    echo -ne "$aPassw\n$aPassw\n" | smbpasswd -a -s $aUser
}
