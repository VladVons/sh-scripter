# Created: 2022.11.08
# Author: Vladimir Vons <VladVons@gmail.com>

source ./common.sh


repo_postgres()
{
    Log "$0->$FUNCNAME($*)"

    PkgInstall "gpg ca-certificates gnupg"
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
    echo "deb http://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" > /etc/apt/sources.list.d/postgresql.list
    ExecM "apt update"
}
