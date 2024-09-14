#!/bin/bash

py=python3
Dir=~/virt/$py
source $Dir/bin/activate
#pip install psutil aiohttp_session cryptography aiopg protego wtforms

$py -B vCrawler.py
