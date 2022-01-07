Dir=~/virtenv/py3

virtualenv -p python3 $Dir --system-site-package
source $Dir/bin/activate

pip install flask
pip install Flask-WTF
pip install flask_login
#pip install mutagen
#pip install openpyxl xlrd
