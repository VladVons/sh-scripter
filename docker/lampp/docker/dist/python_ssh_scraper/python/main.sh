PostInstall()
{
    # user cant access /root folder, so copy to its home
    File=requires.lst
    FileDst=/home/$cSuperUser/$File
    cp $File $FileDst
    chown $cSuperUser $FileDst

    sys_ExecAs $cSuperUser "pip3 install -r $File"
    rm $FileDst
}
