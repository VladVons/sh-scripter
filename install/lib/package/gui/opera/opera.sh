PreInstall()
{
    File=/etc/apt/sources.list.d/opera.list
    echo "deb https://deb.opera.com/opera-stable/ stable non-free" > $File
}
