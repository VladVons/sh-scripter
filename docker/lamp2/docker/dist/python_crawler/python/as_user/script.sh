DirPy=~/virt/python3

PyVirt()
{
    echo "creating local python..."
    python3 -m venv $Dir
    #virtualenv -p python3.12 $DirPy --system-site-package
}


PyPkg()
{
    echo "installing python packages..."

    source $DirPy/bin/activate
    pip3 install --upgrade pip
    pip3 install --requirement requires.lst
}

PlayWright()
{
    source $DirPy/bin/activate
    pip3 install playwright
    playwright install
}

echo "=== run as user $(whoami) ==="
PyVirt
PyPkg
PlayWright
