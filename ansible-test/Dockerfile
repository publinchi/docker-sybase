FROM quay.io/ansible/centos7-test-container:1.26.0

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com" \
      org.label-schema.url="https://github.com/fjudith/docker-sybase/blob/master/README.md" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.vcs-url="https://github.com/fjudith/docker-sybase.git" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.docker.dockerfile="ansible-test/Dockerfile" \
      org.label-schema.description="SAP OpenClient on Ansible-Test OCI image" \
      org.label-schema.schema-version="1.0" 


# ===============================================
# Install Sybase
# ===============================================
ENV SYBASE="/opt/sybase"

RUN yum install -y \
    'compat-libstdc++-33-3.2.3-72.el7.x86_64' \
    'libaio' \
    'glibc' \
    'compat-glibc-2.5-46.2.x86_64' \
    'glibc.i686' \
    'libXtst-devel' \
    'libXi-devel' \
    'openmotif-devel' \
    'libXmu-devel' \
    'libXt-devel' \
    'libXext-devel' \
    'libXp-devel' \
    'libX11-devel' \
    'libSM-devel' \
    'libICE-devel' \
    && \
    yum clean all && \
    rm -rf /usr/share/fonts/* \
        /usr/share/i18n/* \
        /usr/share/sgml/docbook/xsl-stylesheets* \
        /usr/share/adobe/resources/*

# Copy interfaces template
COPY sap-ocs/templates/interfaces.tpl /tmp/interfaces.tpl

# Install SAP OCS
COPY sap-ocs/files/sybase-response.txt /tmp/sybase-response.txt
COPY sap-ase/packages/ASE_Suite.linuxamd64.tgz ./
RUN set -x  && \
    mkdir -p /tmp/ && \
    tar xfz ASE_Suite.linuxamd64.tgz -C /tmp/  && \
    rm -rf ASE_Suite.linuxamd64.tgz && \
    /tmp/ASE_Suite/setup.bin -f /tmp/sybase-response.txt \
        -i silent \
        -DAGREE_TO_SAP_LICENSE=true \
        -DRUN_SILENT=true && \
    rm -rf /tmp/ASE_Suite /tmp/sybase-response.txt

# Configure Entrypoint to source Sybase variables
COPY sap-ocs/scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# ===============================================
# Install Python 2.6 to 3.9
# ===============================================
ENV GPG_KEY="E3FF2839C048B25C084DEBE9B26995E310250568"
ENV PYTHON26='2.6.9' \
    PYTHON35='3.5.9' \
    PYTHON36='3.6.9' \
    PYTHON37='3.7.9' \
    PYTHON38='3.8.5' \
    PYTHON39='3.9.1'

RUN export PATH=${PATH}:/usr/local/bin | tee -a /etc/environment && \
    yum -y update && \
    yum -y groupinstall "Development Tools" && \
    yum -y install \
        'epel-release' \
        'dnf' \
        'bluez-libs' \
        'glibc-devel' \
        'openssl-devel' \
        'bzip2-devel' \
        'libffi-devel' \
        'libxslt-devel' \
        'libxml-devel' \
        'libxml2-devel' \
        'libyaml-devel' \
        'libsqlite3x-devel' \
        'libselinux-python' \
        'libselinux-python3' \
        'wget' \
    && \
    yum clean all && \
    rm -rf \
        /usr/share/fonts/* \
        /usr/share/i18n/* \
        /usr/share/sgml/docbook/xsl-stylesheets* \
        /usr/share/adobe/resources/*

RUN set -e && \
    for i in ${PYTHON26} ${PYTHON35} ${PYTHON36} ${PYTHON37} ${PYTHON38} ${PYTHON39}; do \
        wget "https://www.python.org/ftp/python/${i}/Python-${i}.tgz"  && \
        tar xvf Python-${i}.tgz && \
        cd Python-${i} && \
        ./configure --enable-optimizations && \
        make altinstall && \
        ln -sf /usr/local/bin/python${i:0:3} /usr/bin/python${i:0:3} && \
        ln -sf /usr/local/bin/pip${i:0:3} /usr/bin/pip${i:0:3} && \
        cd ../ && \
        rm -rf Python-${PYTHON36} Python-${PYTHON36}.tgz; \
    done

# ===============================================
# Install default-test-container resources
# ref: https://github.com/ansible/default-test-container
# ===============================================
ENV DEFAULT_TEST_VERSION="2.9.0"
WORKDIR /tmp
RUN curl -L https://github.com/ansible/default-test-container/archive/${DEFAULT_TEST_VERSION}.tar.gz | tar xvzf - && \
    cp default-test-container-${DEFAULT_TEST_VERSION}/files/requirements.sh /tmp/requirements.sh && \
    cp default-test-container-${DEFAULT_TEST_VERSION}/files/early-requirements.txt /tmp/ && \
    cp -r default-test-container-${DEFAULT_TEST_VERSION}/requirements /tmp/requirements && \
    cp -r default-test-container-${DEFAULT_TEST_VERSION}/freeze /tmp/freeze && \
    rm -rf default-test-container-${DEFAULT_TEST_VERSION}
WORKDIR /

ENV container=docker
CMD ["/sbin/init", "--log-target=journal"]

# Install pip and requirements last to speed up local container rebuilds when updating requirements. 

ADD https://bootstrap.pypa.io/2.6/get-pip.py /tmp/get-pip2.6.py
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN /tmp/requirements.sh 2.6
RUN /tmp/requirements.sh 3.5
RUN /tmp/requirements.sh 3.7
RUN /tmp/requirements.sh 3.8
RUN /tmp/requirements.sh 3.9
RUN /tmp/requirements.sh 3.6

ENV PIP_VERSION='20.3.1'
RUN python /tmp/get-pip.py && \
    for i in ${PYTHON35} ${PYTHON36} ${PYTHON37} ${PYTHON38} ${PYTHON39}; do \
        python${i:0:3} /tmp/get-pip.py; \
    done \
    && \
    ln -sf "/usr/local/bin/pip3.6" "/usr/local/bin/pip3" && \
    ln -sf "/usr/local/bin/pip3.6" "/usr/bin/pip3" && \
    ln -sf "/usr/local/bin/python3.6" "/usr/local/bin/python3" && \
    ln -sf "/usr/local/bin/python3.6" "/usr/bin/python3" && \
    rm -f /usr/local/bin/pip /usr/local/bin/pip2