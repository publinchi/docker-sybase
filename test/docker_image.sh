#!/bin/bash
set -e

echo "Wait for Sysbase listen port"
timeout 30s bash << EOF
until nc -vz localhost 5000 > /dev/null 2>1
do 
  printf '.' && sleep 1
done
EOF
echo " "

echo "Wait for Sybase master database"
timeout 30s bash << EOF
until docker exec sybase isql -U sa -P myPassword -S MYSYBASE -D master
do
  printf '.' && sleep 1
done
EOF
echo " "

docker container logs sybase

echo "Create CI test database"
docker exec -i sybase isql -U sa -P myPassword -S MYSYBASE -D master << EOF
select 'name,id' from sysobjects
go
create database cidb on master = '24m'
go
create login 'ciuser' with password 'continuous_integration'
go
use cidb
go
sp_adduser 'ciuser', 'ciuser', null  
go      
EOF