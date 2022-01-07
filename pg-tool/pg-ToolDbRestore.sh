#!/bin/bash
#--- VladVons@gmail.com
# 2021.12.10


source ./pg-CommonTool.sh


#---
DbList
WaitKey
Log

BackupFile="zpk-vm-deb10-pg11-1c_211219_2315_zpk1.sql.zst "
DbRestoreCreate $cDbDefault $BackupFile

Log "$0, $FUNCNAME. Done"
