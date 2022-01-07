# VladVons@gmail.com


Arch_UnzipUrl()
{
    local aUrl="$1"; local aDir="$2";

    wget $aUrl
    mkdir -p $aDir

    File=$(basename $aUrl)
    Ext=${File##*.}
    if [ $Ext == "zip" ]; then
        unzip -q -o $File -d $aDir
    elif [ $Ext == "gz" ]; then
        tar xvzf $File -C $aDir
    fi
    rm $File
}

Arch_Install()
{
    apt install unzip p7zip-full wget
}
