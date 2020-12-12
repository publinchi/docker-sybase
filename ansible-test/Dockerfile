FROM quay.io/ansible/centos7-test-container:1.26.0

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com" \
      org.label-schema.url="https://github.com/fjudith/docker-sybase/blob/master/README.md" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.vcs-url="https://github.com/fjudith/docker-sybase.git" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.docker.dockerfile="ansible-test/Dockerfile" \
      org.label-schema.description="SAP OpenClient on Ansible-Test OCI image" \
      org.label-schema.schema-version="1.0" 

ENV SYBASE="/opt/sybase"

RUN yum install -y \
    compat-libstdc++-33-3.2.3-72.el7.x86_64 \
    libaio \
    glibc \
    compat-glibc-2.5-46.2.x86_64 \
    glibc.i686 \
    libXtst-devel \
    libXi-devel \
    openmotif-devel \
    libXmu-devel \
    libXt-devel \
    libXext-devel \
    libXp-devel \
    libX11-devel \
    libSM-devel \
    libICE-devel \
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

# Python 2.7, 3.5, 3.6, 3.7, 3.8, 3.9
COPY ansible-test/scripts/install_python_releases.sh /tmp/
RUN yum -y update && \
    yum -y groupinstall "Development Tools" && \
    yum -y install \
    libselinux-python \
    libselinux-python3 \
    && \
    yum clean all && \
    rm -rf /usr/share/fonts/* \
        /usr/share/i18n/* \
        /usr/share/sgml/docbook/xsl-stylesheets* \
        /usr/share/adobe/resources/* && \
    chmod +x /tmp/install_python_releases.sh && \
    /tmp/install_python_releases.sh

WORKDIR /tmp
RUN curl -L https://github.com/ansible/default-test-container/archive/2.9.0.tar.gz | tar xvzf - && \
    cp default-test-container-2.9.0/files/requirements.sh /tmp/requirements.sh && \
    cp default-test-container-2.9.0/files/early-requirements.txt /tmp/ && \
    cp -r default-test-container-2.9.0/requirements /tmp/requirements && \
    cp -r default-test-container-2.9.0/freeze /tmp/freeze && \
    rm -rf default-test-container-2.9.0
WORKDIR /

ADD https://bootstrap.pypa.io/2.6/get-pip.py /tmp/get-pip2.6.py
ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN /tmp/requirements.sh 2.6
RUN /tmp/requirements.sh 2.7
RUN /tmp/requirements.sh 3.5
RUN /tmp/requirements.sh 3.7
RUN /tmp/requirements.sh 3.8
RUN /tmp/requirements.sh 3.9
RUN /tmp/requirements.sh 3.6

CMD ["/sbin/init", "--log-target=journal"]