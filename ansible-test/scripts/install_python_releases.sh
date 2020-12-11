#!/usr/bin/env bash

PYTHON37=${PYTHON37:-'3.7.9'}
PYTHON38=${PYTHON38:-'3.8.5'}
PYTHON39=${PYTHON39:-'3.9.1'}

echo PATH=${PATH}:/usr/local/bin | tee -a /etc/environment

set -e

sudo yum -y update && \
sudo yum -y groupinstall "Development Tools" && \
sudo yum -y install \
openssl-devel \
bzip2-devel \
libffi-devel \
wget \
&& \
# Cleanup
yum clean all && \
rm -rf  /usr/share/fonts/* \
        /usr/share/i18n/* \
        /usr/share/sgml/docbook/xsl-stylesheets* \
        /usr/share/adobe/resources/*

## Python 3.7
echo "Install Python version ${PYTHON37}"
wget https://www.python.org/ftp/python/${PYTHON37}/Python-${PYTHON37}.tgz && \
tar xvf Python-${PYTHON37}.tgz && \
cd Python-${PYTHON37} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -s /usr/local/bin/python${PYTHON37:0:3} /usr/bin/python${PYTHON37:0:3} && \
ln -s /usr/local/bin/python${PYTHON37:0:3}m /usr/bin/python${PYTHON37:0:3}m && \
ln -s /usr/local/bin/python${PYTHON37:0:3}m-config /usr/bin/python${PYTHON37:0:3}m-config && \
ln -s /usr/local/bin/pip${PYTHON37:0:3} /usr/bin/pip${PYTHON37:0:3} && \
rm -rf Python-${PYTHON38} Python-${PYTHON37}.tgz

## Python 3.8
echo "Install Python version ${PYTHON38}"
wget https://www.python.org/ftp/python/${PYTHON38}/Python-${PYTHON38}.tgz && \
tar xvf Python-${PYTHON38}.tgz && \
cd Python-${PYTHON38} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -s /usr/local/bin/python${PYTHON38:0:3} /usr/bin/python${PYTHON38:0:3} && \
ln -s /usr/local/bin/python${PYTHON38:0:3}-config /usr/bin/python${PYTHON38:0:3}-config && \
ln -s /usr/local/bin/pip${PYTHON38:0:3} /usr/bin/pip${PYTHON38:0:3} && \
rm -rf Python-${PYTHON38} Python-${PYTHON38}.tgz

## Python 3.9
echo "Install Python version ${PYTHON39}"
wget https://www.python.org/ftp/python/${PYTHON39}/Python-${PYTHON39}.tgz && \
tar xvf Python-${PYTHON39}.tgz && \
cd Python-${PYTHON39} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -s /usr/local/bin/python${PYTHON39:0:3} /usr/bin/python${PYTHON39:0:3} && \
ln -s /usr/local/bin/python${PYTHON39:0:3}-config /usr/bin/python${PYTHON39:0:3}-config && \
ln -s /usr/local/bin/pip${PYTHON39:0:3} /usr/bin/pip${PYTHON39:0:3} && \
rm -rf Python-${PYTHON39} Python-${PYTHON39}.tgz
