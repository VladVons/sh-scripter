_Requires()
{
    # user cant access /root folder, so copy to its home
    Dir=as_user
    DirDst=/home/$cSuperUser/$Dir
    rm -rf $DirDst
    cp -r $Dir $DirDst
    chown -R $cSuperUser $DirDst

    sys_ExecAs $cSuperUser "./script.sh" "$DirDst"
    #rm -r $DirDst
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
