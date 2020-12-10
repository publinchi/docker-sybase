#!/bin/sh
SERVER_NAME=${SERVER_NAME:='MYSYBASE'}
SERVER_HOST=${SERVER_HOST:='sybase'}
SERVER_PORT=${SERVER_PORT:='5000'}
SERVER_BACKUP_PORT=${SERVER_BACKUP_PORT:='5001'}

source ${SYBASE}/SYBASE.sh && \
source /tmp/interfaces.tpl | tee ${SYBASE}/interfaces
exec "$@"
