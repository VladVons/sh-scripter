PostInstall()
{
    #https://github.com/AdguardTeam/AdGuardHome

    curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
}
