# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

cVer="1.0.5, 2022-11-13"
cDirInit="/etc/init.d"
cFileLog="$PWD/docker.log"

source /etc/os-release

for File in ./lib/*.sh; do
    source $File
done



About()
{
    echo "vDocker. Ver $cVer. VladVons@gmail.com"
    echo "apache, php, python, mariadb, postgres, ssh"
}
