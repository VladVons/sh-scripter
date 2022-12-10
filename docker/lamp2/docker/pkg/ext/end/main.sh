PostInstall()
{
    chown -R $cSuperUser /home/$cSuperUser
    echo ". ~/.bashrc-user" >> /home/$cSuperUser/.bashrc

    log_SetColor g
    log_Print "---- REMEMBER ----"
    log_Print "user: $cSuperUser"
    log_Print "password: $cSuperUserPassw"
    log_Print "------------------"
    log_SetColor
}
