PreInstall()
{
  add-apt-repository ppa:alessandro-strada/ppa
}


PostInstall()
{
  Dir=$(pwd)
  runuser -l $cUser -c "$Dir/AsUser.sh"
}
