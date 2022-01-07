Install()
{
    Dev=$(mount -f -v / | grep mmc | awk '{print $2}')
    if [ "$Dev" ]; then
        cd log2ram-master
        chmod +x install.sh
        ./install.sh
    else
        echo "No slow MMC memory detected. Skip install"
    fi
}


Update()
{
    File=log2ram.tar.gz
    wget https://github.com/azlux/log2ram/archive/$File 
    tar xf $File

    Install
}


PostInstall()
{
    Install
}
