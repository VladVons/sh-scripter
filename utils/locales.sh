#!/bin/bash
#--- VladVons@gmail.com

#Loc="en_US"
Loc="uk_UA"

locale-gen ${Loc} ${Loc}.UTF-8
update-locale LC_ALL=${Loc}.UTF-8 LANG=${Loc}.UTF-8
dpkg-reconfigure locales

dpkg-reconfigure tzdata
