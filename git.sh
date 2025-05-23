#!/bin/bash
# Created: 28.09.2016
# Vladimir Vons, VladVons@gmail.com

User="VladVons"
Mail="vladvons@gmail.com"
Url="https://github.com/$User/sh-scripter.git"


Log()
{
  aMsg="$1";

  Msg="$(date +%Y-%m-%d-%a), $(date +%H:%M:%S), $(id -u -n), $aMsg"
  echo "$Msg"
}

Clean()
{
  echo
  echo "Statistics *.sh"
  find . -name '*.sh' | xargs wc
}

GitAuth()
{
  Log "$0->$FUNCNAME"

  #sudo chown -R $USER .

  # sign with eMail
  git config --global user.email $Mail
  git config --global user.name $User

  # no password 
  git config --global credential.helper 'cache --timeout=36000'
}

GitCreate()
{
  Log "$0->$FUNCNAME"

  # create new project on disk
  git init
  GitAuth

  # remote git server location
  git remote add origin $Url

}

GitClone()
{
  Log "$0->$FUNCNAME"

  # restore clone copy fromserver to disk 
  git clone $Url
  GitAuth

  #web admin access here
  #https://github.com/VladVons/appman
}


GitReset()
{
  Log "$0->$FUNCNAME"

  git checkout --orphan TEMP_BRANCH
  git add -A
  git commit -am "Initial commit"
  git branch -D master
  git branch -m master
  git push -f origin master
}


GitSyncToServ()
# sync only changes from disk to server 
{
  aComment="$1";
  Log "$0->$FUNCNAME"

  git status

  #git add install.sh
  #git rm TestClient.py
  #git mv README.md README
  #git log

  git add -u -v
  git commit -a -m "$aComment"

  git push -u origin master
  #git push -u origin master -f
}

GitFromServ()
# sync changes from server to disk
{
  Log "$0->$FUNCNAME"

  git pull
}

GitToServ()
# sync changes from disk to serv
{
  aComment=${1:-"MyCommit"};
  Log "$0->$FUNCNAME"

  Clean
  # add all new files
  git add -A -v
  GitSyncToServ "$aComment"
}

GitFromServF()
# sync changes from server to disk force
{
  Log "$0->$FUNCNAME($*)"

  git reset --hard origin/master
  git fetch --all
}

Diff(){
  diff -r dir1 dir2 | sed '/Binary\ files\ /d' > diff.txt
}

#GitUpdate

clear
case $1 in
    Clean)              "$1"        "$2" "$3" ;;
    GitAuth)            "$1"        "$2" "$3" ;;
    GitCreate)          "$1"        "$2" "$3" ;;
    GitToServ|t)        GitToServ   "$2" "$3" ;;
    GitFromServ|f)      GitFromServ "$2" "$3" ;;
    GitFromServF|ff)    GitFromServF "$2" "$3" ;;
    GitClone)           "$1"        "$2" "$3" ;;
esac

