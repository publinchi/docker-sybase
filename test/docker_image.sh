#!/bin/bash
set -e

echo "Wait for Sysbase listen port"
timeout 30s bash << EOF
until nc -vz localhost 5000 > /dev/null 2>&1
do 
  printf '.' && sleep 1
done
EOF
echo " "

echo "Wait for Sybase master database"
timeout 30s bash << EOF
until docker exec sybase isql -U sa -P myPassword -S MYSYBASE -D master > /dev/null 2>&1
do
  printf '.' && sleep 1
done
EOF
echo " "

docker container logs sybase

echo "Create CI test database"
docker exec -i sybase isql -U sa -P myPassword -S MYSYBASE -D master << EOF
select name,id from sysobjects
go
create database cidb on master = '48m'
go
create login ciuser with password continuous_integration
go
use cidb
go
sp_adduser ciuser, ciuser, null  
go
create table ci_test(
  id      numeric (10,0)   identity primary key,
  value   int             not null    
)
go
insert into ci_test values (${RANDOM})
insert into ci_test values (${RANDOM})
insert into ci_test values (${RANDOM})
insert into ci_test values (${RANDOM})
insert into ci_test values (${RANDOM})
go
EOF