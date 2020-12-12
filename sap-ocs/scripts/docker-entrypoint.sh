#!/bin/sh

SERVER_NAME=${SERVER_NAME:='MYSYBASE'}
SERVER_HOST=${SERVER_HOST:='sybase'}
SERVER_PORT=${SERVER_PORT:='5000'}
SERVER_BACKUP_PORT=${SERVER_BACKUP_PORT:='5001'}

source ${SYBASE}/SYBASE.sh && \
mv /tmp/interfaces.tpl ${SYBASE}/interfaces && \
sed -i "s#__SERVER_NAME__#${SERVER_NAME}#g" ${SYBASE}/interfaces && \
sed -i "s#__SERVER_HOST__#${SERVER_HOST}#g" ${SYBASE}/interfaces && \
sed -i "s#__SERVER_PORT__#${SERVER_PORT}#g" ${SYBASE}/interfaces && \
sed -i "s#__SERVER_BACKUP_PORT__#${SERVER_BACKUP_PORT}#g" ${SYBASE}/interfaces && \
exec "$@"