UserConf()
{
    local aPgBin=$1;
    log_Print "$0->$FUNCNAME($*)"

    sys_ExecAs postgres "$aPgBin/psql -U postgres -d template1 -c \"CREATE USER $cSuperUser WITH SUPERUSER PASSWORD '$cSuperUserPassw';\""
    sys_ExecAs postgres "$aPgBin/psql -U postgres -d template1 -c \"CREATE DATABASE test1;\""
    sys_ExecAs postgres "$aPgBin/psql -l -U postgres"
}

PkgInstallVer()
{
    local aVer=$1;

    pkg_Install "postgresql-${aVer} postgresql-contrib-${aVer}"
    $cDirInit/postgresql start
    sleep 0.5
    #pg_createcluster --start $Ver main

    PgBin="/usr/lib/postgresql/$aVer/bin"
    UserConf $PgBin
}

PreInstall()
{
    log_Print "$0->$FUNCNAME($*)"

    pkg_Install "curl gpg ca-certificates gnupg"
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null
    echo "deb http://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" > /etc/apt/sources.list.d/postgresql.list
    sys_ExecM "apt update"
}

PostInstall()
{
    local aVer=$1;

    for Ver in $gPkgArg; do
        PkgInstallVer $Ver
        app_CopyFile "_$Ver"
    done

    #usermod -G staff postgres
}
