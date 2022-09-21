FROM centos:7

LABEL MAINTAINER="Florian JUDITH <florian.judith.b@gmail.com>"

ENV SYBASE="/opt/sybase"
ENV PATH=${PATH}:${SYBASE}/ASE-16_0/bin/:${SYBASE}/OCS-16_0/bin

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
    gpg --batch --verify /tini.asc /tini && \
    chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Installing Sybase RPMs
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

# Setting kernel.shmmax and
COPY files/sysctl.conf /etc/
RUN set -x && \
    true || /sbin/sysctl -p


# Install Sybase | Build ASE Server
COPY files/sybase-response.txt /tmp/
COPY packages/ASE_Suite.linuxamd64.tgz ./
RUN set -x  && \
    mkdir -p /tmp/ && \
    tar xfz ASE_Suite.linuxamd64.tgz -C /tmp/  && \
    rm -rf ASE_Suite.linuxamd64.tgz && \
    /tmp/ASE_Suite/setup.bin -f /tmp/sybase-response.txt \
        -i silent \
        -DAGREE_TO_SAP_LICENSE=true \
        -DRUN_SILENT=true && \
    rm -rf /tmp/ASE_Suite /tmp/sybase-response.txt

# RUN set -x  && \
#     curl -OLS http://repository.transtep.com/repository/thirdparty/sybase/ASE16SP02/ASE_Suite.linuxamd64.tgz  && \
#     mkdir -p /tmp/ && \
#     tar xfz ASE_Suite.linuxamd64.tgz -C /tmp/  && \
#     rm -rf ASE_Suite.linuxamd64.tgz && \
#     /tmp/ASE_Suite/setup.bin -f /tmp/sybase-response.txt \
#         -i silent \
#         -DAGREE_TO_SAP_LICENSE=true \
#         -DRUN_SILENT=true && \
#     rm -rf /tmp/ASE_Suite /tmp/sybase-response.txt

# Build ASE server
COPY files/sybase-ase.rs /tmp/
RUN source ${SYBASE}/SYBASE.sh && \
    mv /tmp/sybase-ase.rs ${SYBASE}/ASE-16_0/sybase-ase.rs && \
    ${SYBASE}/ASE-16_0/bin/srvbuildres -r ${SYBASE}/ASE-16_0/sybase-ase.rs

# Change the Sybase interface
# Set the Sybase startup script in entrypoint.sh
COPY files/interfaces /tmp/
RUN mv ${SYBASE}/interfaces ${SYBASE}/interfaces.backup && \
    mv /tmp/interfaces ${SYBASE}/
 
EXPOSE 5000

# Share the Sybase data directory
#VOLUME ["${SYBASE}/data"]

# When run it
# docker run -d -p 8000:5000 -p 8001:5001 --name my-sybase sybase

COPY scripts/start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]