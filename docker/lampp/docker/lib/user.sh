# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

user_Add()
{
    log_Print "$0->$FUNCNAME($*)"
    local aUser=$1; aPassw=$2;

    local Home=/home/$aUser

    gPASS=${aPassw:-$(pwgen -s 8 1)}
    sys_ExecM "useradd $aUser --groups sudo --home-dir $Home --create-home --shell /bin/bash"
    echo -e "$gPASS\n$gPASS\n" | passwd $aUser
    echo "Added user: $aUser, passw: $gPASS"
}
