PostInstall()
{
    chown -R $cSuperUser /home/$cSuperUser
    echo ~/.bashrc-user >> /home/$cSuperUser/.bashrc
}
