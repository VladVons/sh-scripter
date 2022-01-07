# VladVons@gmail.com

PostInstall()
{
    Dir=$(pwd)
    runuser -l $USER -c "$Dir/AsUser.sh"

    update-rc.d vvncserver defaults
    update-rc.d vvncserver enable
}
