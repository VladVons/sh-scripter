# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

user_Add()
{
    log_Print "$0->$FUNCNAME($*)"
    local aUser=$1; aPassw=$2;

    local Home=/home/$aUser

    sys_ExecM "useradd $aUser --groups sudo --home-dir $Home --create-home --shell /bin/bash"
    echo -e "$aPassw\n$aPassw\n" | passwd $aUser
    log_Print "Added user: $aUser, passw: $aPassw"
}
