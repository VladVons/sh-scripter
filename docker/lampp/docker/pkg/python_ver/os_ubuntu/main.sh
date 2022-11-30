PreInstall()
{
    pkg_Install "software-properties-common"
    sys_ExecM "add-apt-repository --yes ppa:deadsnakes/ppa"
}
