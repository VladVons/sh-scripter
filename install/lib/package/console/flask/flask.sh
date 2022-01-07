# VladVons@gmail.com

source $cDirLib/user.sh


PreInstall()
{
    User=flask
    User_Add $User $User /home

    Dir=$(pwd)
    runuser -l $User -c "$Dir/AsUser.sh"
}
