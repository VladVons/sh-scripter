#!/bin/bash

aUrl="http://download.oster.com.ua/image/dev/xtensa-lx106-elf_lnk-min.tar.gz"
wget --no-check-certificate $aUrl
File=$(basename $aUrl)
tar xf $File
rm $File
