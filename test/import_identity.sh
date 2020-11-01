#!/bin/bash

echo "Create super hero database"
docker exec -i sybase isql -U sa -P myPassword -S MYSYBASE -D master << EOF
CREATE TABLE superhero (
  id numeric (10,0) identity primary key,
  firstname nvarchar(255) not null,
  lastname  nvarchar(255) not null
)
go
EOF

echo "Import super hero using bcp"
docker exec -i sybase \
bcp master.dbo.superhero in /var/lib/dataset/super_hero.csv \
-U sa -P myPassword -S MYSYBASE \
-c -t ',' -r '\n'

echo "Create fake names database"
docker exec -i sybase isql -U sa -P myPassword -S MYSYBASE -D master << EOF
CREATE TABLE fakenames (
  number numeric (10,0) identity primary key,
  gender nvarchar(6) not null,
  nameset nvarchar(25) not null,
  title nvarchar(6) not null,
  givenname nvarchar(20) not null,
  middleinitial nvarchar(1) not null,
  surname nvarchar(23) not null,
  streetaddress nvarchar(100) not null,
  city nvarchar(100) not null,
  state nvarchar(22) not null,
  statefull nvarchar(100) not null,
  zipcode nvarchar(15) not null,
  country nvarchar(2) not null,
  countryfull nvarchar(100) not null,
  emailaddress nvarchar(100) not null,
  username varchar(25) not null,
  password nvarchar(25) not null,
  browseruseragent nvarchar(255) not null,
  telephonenumber nvarchar(25) not null,
  telephonecountrycode int not null,
  maidenname nvarchar(23) not null,
  birthday datetime not null,
  age int not null,
  tropicalzodiac nvarchar(11) not null,
  cctype nvarchar(10) not null,
  ccnumber nvarchar(16) not null,
  cvv2 nvarchar(3) not null,
  ccexpires nvarchar(10) not null,
  nationalid nvarchar(20) not null,
  upstracking nvarchar(24) not null,
  westernunionmtcn nchar(10) not null,
  moneygrammtcn nchar(8) not null,
  color nvarchar(6) not null,
  occupation nvarchar(70) not null,
  company nvarchar(70) not null,
  vehicle nvarchar(255) not null,
  domain nvarchar(70) not null,
  bloodtype nvarchar(3) not null,
  pounds decimal(5,1) not null,
  kilograms decimal(5,1) not null,
  feetinches nvarchar(6) not null,
  centimeters smallint not null,
  guid nvarchar(36) not null,
  latitude numeric(10,6) not null,
  longitude numeric(10,6) not null
)
go
EOF

echo "Import fake names using bcp"
docker exec -i sybase \
bcp master.dbo.fakenames in /var/lib/dataset/10k_identity_fra.csv \
-U sa -P myPassword -S MYSYBASE \
-J utf8 -Y -f /var/lib/dataset/bcp.fmt
#-c -J utf8 -Y -T -t ',' -r '\n' -m '1000000'