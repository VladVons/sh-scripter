# Created: 2022.11.11
# Author: Vladimir Vons <VladVons@gmail.com>

app_CopyFile()
{
    local aVer=$1;
    log_Print "$0->$FUNCNAME($*)($PWD)"

    Dir="f_static$aVer"
    if [ -d $Dir ]; then
        log_Print "$0->$FUNCNAME, $Dir"
        #cp -rb $Dir/* / 2>/dev/null
        sys_ExecM "cp -rf $Dir/* / 2>/dev/null"
    fi
}
