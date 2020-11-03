#!/bin/bash

export LC_ALL=fr_FR.UTF-8
export LANG=fr_FR.UTF-8
export LANGUAGE=fr_FR.UTF-8

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

cat << EOF | sudo tee /etc/odbcinst.ini
[FreeTDS]
Description=FreeTDS Driver
Driver=/usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so
Setup=/usr/lib/x86_64-linux-gnu/odbc/libtdsS.so
EOF

pip3 install -qr ./test/requirements.txt
python3 ./test/import_fakenames.py