PreInstall()
{
  source /etc/lsb-release

  wget -q https://download.docker.com/linux/ubuntu/gpg -O- | apt-key add -
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $DISTRIB_CODENAME stable"
}


PostInstall()
{
  systemctl status docker
  usermod -aG docker $USER
}
