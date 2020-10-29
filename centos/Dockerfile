FROM nguoianphu/docker-sybase:latest

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com>"

ENV SYBASE="/opt/sybase"
ENV PATH=${PATH}:${SYBASE}/ASE-16_0/bin/:${SYBASE}/OCS-16_0/bin

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && \
    gpg --batch --verify /tini.asc /tini && \
    chmod +x /tini
ENTRYPOINT ["/tini", "--"]

ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

EXPOSE 5000