PkgInstallVer()
{
    local aVer=$1;

    pkg_Install "php${aVer} libapache2-mod-php${Ver} php${aVer}-fpm"
    pkg_Install "php${aVer}-xml php${Ver}-mbstring php${aVer}-soap php${aVer}-gd php${aVer}-zip php${aVer}-mysql php${aVer}-pgsql php${aVer}-xdebug"
    pkg_Install "php${aVer}-mcrypt"
}

PostInstall()
{
    for Ver in $gPkgArg; do
        PkgInstallVer $Ver
    done
}
