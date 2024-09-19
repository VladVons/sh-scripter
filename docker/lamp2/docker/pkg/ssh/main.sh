PostInstall()
{
    user_Add $cSuperUser $cSuperUserPassw

    sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
}
