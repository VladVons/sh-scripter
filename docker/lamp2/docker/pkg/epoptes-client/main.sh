_Service()
{
    systemctl daemon-reload
    systemctl enable epoptes-client
    service epoptes-client start
}

PostInstall()
{
    _Service

    # initialize
    epoptes-client -c
}
