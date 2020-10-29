FROM nguoianphu/docker-sybase:latest

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com>"

ENV SYBASE_HOME="/opt/sybase"

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

ADD start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

EXPOSE 5000