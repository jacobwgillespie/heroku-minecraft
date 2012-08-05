#!/bin/bash
curl -s https://raw.github.com/pypa/virtualenv/master/virtualenv.py > virtualenv.py
python virtualenv.py my_new_env
. my_new_env/bin/activate
pip install boto_rsync
