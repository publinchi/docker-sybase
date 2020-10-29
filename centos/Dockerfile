FROM nguoianphu/docker-sybase:latest

LABEL maintainer="Florian JUDITH <florian.judith.b@gmail.com>"

ENV SYBASE_HOME=/opt/sybase

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]