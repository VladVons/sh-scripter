_Requires_AsUser()
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

_Requires()
{
    Dir=as_user
    cd $Dir
    ./script.sh
}



_App()
{
    chown -R $cSuperUser /usr/lib/vCrawler
}

_Service()
{
    systemctl daemon-reload
    systemctl enable vCrawler.service
}


PostInstall()
{
    #_Requires_AsUser
    _Requires
    _App
    _Service
}
