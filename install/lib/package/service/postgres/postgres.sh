PreInstall()
{
  source /etc/lsb-release

  echo "deb http://apt.postgresql.org/pub/repos/apt $DISTRIB_CODENAME-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
}
