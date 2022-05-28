PreInstall()
{
    add-apt-repository ppa:deadsnakes/ppa
}

PostInstall()
{
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
}