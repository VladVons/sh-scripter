# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

pkg_Install()
{
    local aPkg=$1;
    log_Print "$0->$FUNCNAME($*)"

    log_SetColor g
    echo "$0->$FUNCNAME($*)"
    log_SetColor

    sys_ExecM "apt-get install --yes --no-install-recommends $aPkg"
}

pkg_Update()
{
    log_Print "$0->$FUNCNAME"

    rm /var/lib/dpkg/lock

    apt-get autoremove --yes
    dpkg --configure -a
    apt install --fix-broken --yes

    apt update --yes
    apt dist-upgrade --yes
}

pkg_Clear()
{
    log_Print "$0->$FUNCNAME"

    rm /var/cache/apt/archives/lock 2>/dev/null
    apt-get autoremove --yes
    apt-get clean --yes
}

pkg_FileListInstall()
{
    local aFile="$1";
    log_Print "$0->$FUNCNAME($*)"
    log_Print "$0->$FUNCNAME($PWD)"

    sed '/^[[:blank:]]*#/d;s/#.*//' $aFile 2>/dev/null |\
    while read Item; do
        pkg_Install "$Item"
    done
}

pkg_FileListInstallSnap()
{
    local aFile="$1";
    log_Print "$0->$FUNCNAME($*)"

    sed '/^[[:blank:]]*#/d;s/#.*//' $aFile 2>/dev/null |\
    while read Item; do
        sys_ExecM "snap install $Item"
    done
}