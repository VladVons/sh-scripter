PkgInstallVer()
{
    local aVer=$1;

    pkg_Install "python${aVer} python${aVer}-dev python${aVer}-venv"

}

install_compile_python()
{
    pkg_Install "python3-setuptools python3-pip"
    pkg_Install "wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev"

    for Ver in $gPkgArg; do
        File="Python-${Ver}.tgz"
        sys_ExecM "wget https://www.python.org/ftp/python/$Ver/$File"

        sys_ExecM "tar -xvf $File"

        FileName="${File%.*}"
        cd "$FileName"
        sys_ExecM "./configure --enable-optimizations"
        sys_ExecM "make & make altinstall"
        cd ..

        rm $File
        rm -R $FileName
    done
}

PostInstall()
{
    for Ver in $gPkgArg; do
        PkgInstallVer $Ver
    done
}
