# Created: 2022.11.08
# Author: Vladimir Vons <VladVons@gmail.com>

source ./common.sh


repo_php()
{
    Log "$0->$FUNCNAME($*)"

    PkgInstall "software-properties-common"
    ExecM "add-apt-repository ppa:ondrej/php"
}

repo_python()
{
    Log "$0->$FUNCNAME($*)"

    PkgInstall "software-properties-common"
    ExecM "add-apt-repository ppa:deadsnakes/ppa"
}
