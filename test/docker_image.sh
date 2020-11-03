#!/bin/bash

set -e

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run
retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $(( attempt_num++ ))
        fi
    done
}

echo "Wait for Sysbase listen port"
retry 30 nc -vz localhost 5000 > /dev/null 2>&1

echo "Wait for Sybase master database creation"
retry 30 docker exec sybase isql -U sa -P myPassword -S MYSYBASE -D master > /dev/null 2>&1


echo "Wait for Sybase master database initailisation"
STATUS=$(docker exec -i sybase bash -c 'grep "Finished initialization." ${SYBASE}/ASE-16_0/install/MYSYBASE.log | wc -c')
until [[ ${STATUS} -gt 400 ]]
do
    STATUS=$(docker exec -i sybase bash -c 'grep "Finished initialization." ${SYBASE}/ASE-16_0/install/MYSYBASE.log | wc -c')
    printf "." && sleep 5
done
echo ""

echo "Create CI test database"
docker exec -i sybase isql -U sa -P myPassword -S MYSYBASE -D master <<-EOSQL
create database cidb on master = '40m'
go
create login ciuser with password continuous_integration
go
exec sp_dboption cidb, 'ddl in tran', true
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
EOSQL