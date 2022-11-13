#!/bin/bash
# Created: 2022.11.07
# Author: Vladimir Vons <VladVons@gmail.com>

source ./install.sh

Build()
{
    log_Print "$0->$FUNCNAME($*)"

    install_Dist v1
    About
    log_Print "Build done"
}

time Build
