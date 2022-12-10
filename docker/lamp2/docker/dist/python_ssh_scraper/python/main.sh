_Requires()
{
    # user cant access /root folder, so copy to its home
    File=requires.lst
    FileDst=/home/$cSuperUser/$File
    cp $File $FileDst
    chown $cSuperUser $FileDst

    sys_ExecAs $cSuperUser "pip3 install -r $File"
    rm $FileDst
}

_App()
{
    chown -R $cSuperUser /usr/lib/vScraper
}

_Service()
{
    systemctl daemon-reload
    systemctl enable vScraper.service
}


PostInstall()
{
    _Requires
    _App
    _Service
}
