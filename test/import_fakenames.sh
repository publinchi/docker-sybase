#!/bin/bash

set -e

# Install required pakages
sudo apt-get install -yq \
    build-essential \
    python3-setuptools \
    freetds-bin \
    freetds-dev \
    libct4 \
    libsybdb5 \
    tdsodbc \
    unixodbc \
    unixodbc-dev

sudo pip3 install pyodbc sqlalchemy pymssql pandas

cat << EOF | sudo tee /etc/odbcinst.ini
[FreeTDS]
Description=FreeTDS Driver
Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so
Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so
EOF

sudo cat /etc/odbcinst.ini
sudo find / -name libtdsodbc.so

pip3 install -r ./test/requirements.txt
python3 ./test/import_fakenames.py