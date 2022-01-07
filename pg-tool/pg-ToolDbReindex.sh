#!/bin/bash
#--- VladVons@gmail.com
# 2021.12.10


source ./pg-CommonTool.sh

#---
ExecAs "psql -l -U postgres"
WaitKey
Log

DbReindex $cDbDefault

Log "$0, $FUNCNAME. Done"
