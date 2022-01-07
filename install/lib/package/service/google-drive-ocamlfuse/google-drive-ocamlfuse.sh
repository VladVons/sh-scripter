PreInstall()
{
  add-apt-repository ppa:alessandro-strada/ppa
}


PostInstall()
{
  Dir=$(pwd)
  runuser -l $USER -c "$Dir/AsUser.sh"
}
