#!/bin/bash
# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

#set -x
#trap 'echo "# $BASH_COMMAND";read' DEBUG
source ./install.sh

Build()
{
    log_Print "$0->$FUNCNAME($*)"

    install_Run
    About
    log_Print "Build done"
}

time Build
