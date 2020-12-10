# Docker Sybase ASE image

[![SAP ASE](https://github.com/fjudith/docker-sybase/workflows/SAP%20Adaptive%20Server%20Enterprise/badge.svg)](https://github.com/fjudith/docker-sybase/actions)
[![SAP OCS](https://github.com/fjudith/docker-sybase/workflows/SAP%20OpenClient/badge.svg)](https://github.com/fjudith/docker-sybase/actions)
[![Ansible-test OpenClient Image](https://github.com/fjudith/docker-sybase/workflows/Ansible-Test%20with%20SAP%20OpenClient/badge.svg)](https://github.com/fjudith/docker-sybase/actions)
[![Ansible PyODBC Image](https://github.com/fjudith/docker-sybase/workflows/Ansible%20with%20PyODBC/badge.svg)](https://github.com/fjudith/docker-sybase/actions)
[![](https://images.microbadger.com/badges/image/fjudith/docker-sybase.svg)](http://microbadger.com/images/fjudith/docker-sybase "Get your own image badge on microbadger.com")
![Docker image](https://github.com/fjudith/docker-sybase/workflows/Docker%20CI/badge.svg)

## Quick start

```bash
docker container run -it --name sybase --rm -p 5000:5000 fjudith/sybase:16.0
```

## Default Authentication

Two users are configured at first boot.

Database | Username | Password | Customization
--- | --- | --- | --- 
`master` | `sa` | `myPassword` | None (static)
`testdb` | `test` | `guest1234`| Environment variable

```bash
docker container exec -i sybase isql -U "sa" -P "myPassword" -S "MYSYBASE" -D "master" <<-EOF
select id,name from sysobjects
go
EOF
```

## Environment variables

* **SYBASE_MASTER_DB_SIZE**: Size of the master database; _default_ `200m`
* **SYBASE_USER**: Test user name; _default_ `tester`
* **SYBASE_PASSWORD**: Test user password; _default_ `guest1234`
* **SYBASE_DB**: Test database name; _default_ `testdb`
* **SYBASE_DB_SIZE**: Test database size (Must be less than 80% of the _SYBASE_MASTER_DB_SIZE_, and at least 24m); _default_ `50m`

## Packages

### SAP ASE Developer Edition (default)

```text
https://go.sap.com/cmp/syb/crm-xu15-int-asewindm/typ.html

http://repository.transtep.com/repository/thirdparty/sybase/ASE16SP02/ASE_Suite.linuxamd64.tgz
http://repository.transtep.com/repository/thirdparty/sybase/ASE16SP02/ASE_Suite.winx64.zip
```

### SAP ASE Express Edition

```text 
http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/ExpressEdition/ase160_linuxx86-64.zip
http://d1cuw2q49dpd0p.cloudfront.net/ASE16.0/DeveloperEdition/ase160_winx64.zip
```


### Build

    docker build -t sybase .
        
### Run
    
    docker run -d -p 8000:5000 -p 8001:5001 --name my-sybase sybase
        
    # or
    docker run -d -p 8000:5000 -p 8001:5001 --name nguoianphu-sybase nguoianphu/docker-sybase
        
#### Check isql

    docker exec -it my-sybase /bin/bash
        
    source /opt/sybase/SYBASE.sh
    isql -U sa -P myPassword -S MYSYBASE
        
    select @@version
    go
        
### Mount licenses

     docker run -d -p 8000:5000 -p 8001:5001 -v /path/to/sybase_licenses:/opt/sybase/SYSAM-2_0/licenses --name my-sybase sybase
        
     # or
     docker run -d -p 8000:5000 -p 8001:5001 -v /path/to/sybase_licenses:/opt/sybase/SYSAM-2_0/licenses --name nguoianphu-sybase nguoianphu/docker-sybase