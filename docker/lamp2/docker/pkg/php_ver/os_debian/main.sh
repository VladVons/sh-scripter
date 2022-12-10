PreInstall()
{
    sys_ExecM "wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg"
    echo "deb https://packages.sury.org/php/ ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/php.list
    sys_ExecM "apt update"
}
