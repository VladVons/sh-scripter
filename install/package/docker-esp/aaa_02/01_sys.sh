PreInstall()
{
  apt update --yes

  #TZ="Europe/Kiev"
  #ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

  #echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
}

PostInstall()
{
  ln -s /usr/bin/python2.7 /usr/bin/python

  User="esp"
  ExecM "adduser --disabled-password --gecos '' $aUser$"
  usermod -aG sudo $User
}
