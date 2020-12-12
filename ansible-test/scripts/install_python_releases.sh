#!/usr/bin/env bash

PYTHON26=${PYTHON26:-'2.6.9'}
PYTHON27=${PYTHON27:-'2.7.18'}
PYTHON35=${PYTHON35:-'3.5.9'}
PYTHON36=${PYTHON36:-'3.6.9'}
PYTHON37=${PYTHON37:-'3.7.9'}
PYTHON38=${PYTHON38:-'3.8.5'}
PYTHON39=${PYTHON39:-'3.9.1'}

echo PATH=${PATH}:/usr/local/bin | tee -a /etc/environment

set -e

sudo yum -y update && \
sudo yum -y groupinstall "Development Tools" && \
sudo yum -y install \
bluez-libs \
glibc-devel \
openssl-devel \
bzip2-devel \
libffi-devel \
libxslt-devel \
libxml-devel \
libxml2-devel \
libyaml-devel \
wget \
&& \
# Cleanup
yum clean all && \
rm -rf  /usr/share/fonts/* \
        /usr/share/i18n/* \
        /usr/share/sgml/docbook/xsl-stylesheets* \
        /usr/share/adobe/resources/*

## Python 2.6
echo "Install Python version ${PYTHON26}"
wget https://www.python.org/ftp/python/${PYTHON26}/Python-${PYTHON26}.tgz && \
tar xvf Python-${PYTHON26}.tgz && \
cd Python-${PYTHON26} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON26:0:3} /usr/bin/python${PYTHON26:0:3} && \
ln -sf /usr/local/bin/python${PYTHON26:0:3}m /usr/bin/python${PYTHON26:0:3}m && \
ln -sf /usr/local/bin/python${PYTHON26:0:3}m-config /usr/bin/python${PYTHON26:0:3}m-config && \
ln -sf /usr/local/bin/pip${PYTHON26:0:3} /usr/bin/pip${PYTHON26:0:3} && \
rm -rf Python-${PYTHON26} Python-${PYTHON26}.tgz

## Python 2.7
echo "Install Python version ${PYTHON27}"
wget https://www.python.org/ftp/python/${PYTHON27}/Python-${PYTHON27}.tgz && \
tar xvf Python-${PYTHON27}.tgz && \
cd Python-${PYTHON27} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON27:0:3} /usr/bin/python${PYTHON27:0:3} && \
ln -sf /usr/local/bin/python${PYTHON27:0:3}m /usr/bin/python${PYTHON27:0:3}m && \
ln -sf /usr/local/bin/python${PYTHON27:0:3}m-config /usr/bin/python${PYTHON27:0:3}m-config && \
ln -sf /usr/local/bin/python${PYTHON27:0:3} /usr/bin/python && \
ln -sf /usr/local/bin/pip${PYTHON27:0:3} /usr/bin/pip${PYTHON27:0:3} && \
ln -sf /usr/local/bin/pip${PYTHON27:0:3} /usr/bin/pip && \
rm -rf Python-${PYTHON27} Python-${PYTHON27}.tgz

## Python 3.5
echo "Install Python version ${PYTHON35}"
wget https://www.python.org/ftp/python/${PYTHON35}/Python-${PYTHON35}.tgz && \
tar xvf Python-${PYTHON35}.tgz && \
cd Python-${PYTHON35} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON35:0:3} /usr/bin/python${PYTHON35:0:3} && \
ln -sf /usr/local/bin/python${PYTHON35:0:3}m /usr/bin/python${PYTHON35:0:3}m && \
ln -sf /usr/local/bin/python${PYTHON35:0:3}m-config /usr/bin/python${PYTHON35:0:3}m-config && \
ln -sf /usr/local/bin/pip${PYTHON35:0:3} /usr/bin/pip${PYTHON35:0:3} && \
rm -rf Python-${PYTHON35} Python-${PYTHON35}.tgz

## Python 3.6
echo "Install Python version ${PYTHON37}"
wget https://www.python.org/ftp/python/${PYTHON36}/Python-${PYTHON36}.tgz && \
tar xvf Python-${PYTHON36}.tgz && \
cd Python-${PYTHON36} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON36:0:3} /usr/bin/python${PYTHON36:0:3} && \
ln -sf /usr/local/bin/python${PYTHON36:0:3}m /usr/bin/python${PYTHON36:0:3}m && \
ln -sf /usr/local/bin/python${PYTHON36:0:3}m-config /usr/bin/python${PYTHON36:0:3}m-config && \
ln -sf /usr/local/bin/python${PYTHON36:0:3} /usr/bin/python3 && \
ln -sf /usr/local/bin/pip${PYTHON36:0:3} /usr/bin/pip${PYTHON36:0:3} && \
ln -sf /usr/local/bin/pip${PYTHON36:0:3} /usr/bin/pip3 && \
rm -rf Python-${PYTHON36} Python-${PYTHON36}.tgz

## Python 3.7
echo "Install Python version ${PYTHON37}"
wget https://www.python.org/ftp/python/${PYTHON37}/Python-${PYTHON37}.tgz && \
tar xvf Python-${PYTHON37}.tgz && \
cd Python-${PYTHON37} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON37:0:3} /usr/bin/python${PYTHON37:0:3} && \
ln -sf /usr/local/bin/python${PYTHON37:0:3}m /usr/bin/python${PYTHON37:0:3}m && \
ln -sf /usr/local/bin/python${PYTHON37:0:3}m-config /usr/bin/python${PYTHON37:0:3}m-config && \
ln -sf /usr/local/bin/pip${PYTHON37:0:3} /usr/bin/pip${PYTHON37:0:3} && \
rm -rf Python-${PYTHON37} Python-${PYTHON37}.tgz

## Python 3.8
echo "Install Python version ${PYTHON38}"
wget https://www.python.org/ftp/python/${PYTHON38}/Python-${PYTHON38}.tgz && \
tar xvf Python-${PYTHON38}.tgz && \
cd Python-${PYTHON38} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON38:0:3} /usr/bin/python${PYTHON38:0:3} && \
ln -sf /usr/local/bin/python${PYTHON38:0:3}-config /usr/bin/python${PYTHON38:0:3}-config && \
ln -sf /usr/local/bin/pip${PYTHON38:0:3} /usr/bin/pip${PYTHON38:0:3} && \
rm -rf Python-${PYTHON38} Python-${PYTHON38}.tgz

## Python 3.9
echo "Install Python version ${PYTHON39}"
wget https://www.python.org/ftp/python/${PYTHON39}/Python-${PYTHON39}.tgz && \
tar xvf Python-${PYTHON39}.tgz && \
cd Python-${PYTHON39} && \
./configure --enable-optimizations && \
sudo make altinstall && \
ln -sf /usr/local/bin/python${PYTHON39:0:3} /usr/bin/python${PYTHON39:0:3} && \
ln -sf /usr/local/bin/python${PYTHON39:0:3}-config /usr/bin/python${PYTHON39:0:3}-config && \
ln -sf /usr/local/bin/pip${PYTHON39:0:3} /usr/bin/pip${PYTHON39:0:3} && \
rm -rf Python-${PYTHON39} Python-${PYTHON39}.tgz
