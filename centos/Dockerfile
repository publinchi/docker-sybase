FROM nguoianphu/docker-sybase:latest

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com>"

ENV SYBASE_HOME="/opt/sybase"

ADD docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/docker-entrypoint.sh"]