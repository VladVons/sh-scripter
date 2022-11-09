# Created: 2022.11.08
# Author: Vladimir Vons <VladVons@gmail.com>

source ./common.sh


repo_php()
{
    Log "$0->$FUNCNAME($*)"

    ExecM "wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg"
    echo "deb https://packages.sury.org/php/ ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/php.list
    ExecM "apt update"
}

repo_python()
{
    Log "$0->$FUNCNAME($*)"
}
