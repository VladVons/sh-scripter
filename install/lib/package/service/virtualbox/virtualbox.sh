# VladVons@gmail.com
# http://oster.com.ua/blog/VladVons/VirtualBox_Medok_Linux

source $cDirLib/net.sh


PreInstall()
{
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

  source /etc/lsb-release
  add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $DISTRIB_CODENAME contrib"
}


PostInstall()
{
    usermod -aG vboxusers $cUser

    #systemctl enable vbox-startvm
}
