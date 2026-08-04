# I. The DC site
## 1. Configure broker

```
ASMCMD [+DATA/ORCL] > mkdir DGBROKER
ASMCMD [+DATA/ORCL/DGBROKER] > pwd
+DATA/ORCL/DGBROKER
```
```
SQL> alter system set dg_broker_config_file1='+DATA/ORCL/DGBROKER/dr1orcl.dat' scope=both sid='*';
System SET altered.

SQL> alter system set dg_broker_config_file2='+DATA/ORCL/DGBROKER/dr2orcl.dat' scope=both sid='*';
System SET altered.

SQL> alter system set dg_broker_start=true scope=both sid='*';
System SET altered.
```
<img width="878" height="196" alt="image" src="https://github.com/user-attachments/assets/de76cbdc-d9be-40c5-aa14-3de9f0d4e856" />

## 2. Configure Standby Redo Log

 - *Attention: Standby Redo Log = Online Redo log + 1*

```
SQL> alter system set db_create_online_log_dest_1='+DATA' scope=both sid='*';
System SET altered.

SQL> alter system set db_create_online_log_dest_2='+FRA' scope=both sid='*';
System SET altered.
```

<img width="428" height="130" alt="image" src="https://github.com/user-attachments/assets/b5c9c062-7fa7-4be5-bee4-dc8f1a51dfc3" />

- *Online Redo log number*
```
set lines 200 pages 200
col member for a85
select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;
```

<img width="1593" height="309" alt="image" src="https://github.com/user-attachments/assets/e0830581-218a-4846-b9d8-08cb1c6c6290" />

- *Standby Redo log number*
```
set lines 200 pages 200
col member for a85
select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$standby_log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;
```
```
SQL> alter database add standby logfile thread 1 group 11 size 200M;
Database altered.

SQL> alter database add standby logfile thread 1 group 12 ('+DATA', '+FRA') SIZE 200M;
Database altered.
```

# II. The DR site

## 1. Copy Password file from DC site to DR site
```
ASMCMD [+DATA/ORCLDR] > mkdir PARAMETERFILE
ASMCMD [+DATA/ORCLDR] > mkdir PASSWORD
ASMCMD [+DATA/ORCLDR] > mkdir CONTROLFILE
ASMCMD [+FRA/ORCLDR] > mkdir CONTROLFILE
```

```
ASMCMD [+DATA/ORCLDR/PASSWORDFILE] > pwcopy --dbuniquename orcldr /u01/app/oracle/product/19c/dbhome_1/dbs/orapworcl +DATA/ORCLDR/PASSWORD/orapworcl
copying /u01/app/oracle/product/19c/dbhome_1/dbs/orapworcl -> +DATA/ORCLDR/PASSWORD/orapworcl
ASMCMD [+DATA/ORCLDR/PASSWORDFILE] > ls
orapworcl
```
## 2. Add Instance DR to SRVCTL
```
srvctl add database \
  -d orcldr \
  -o /u01/app/oracle/product/19c/dbhome_1 \
  -p +DATA/ORCLDR/PARAMETERFILE/spfileorcldr.ora \
  -r PHYSICAL_STANDBY \
  -s OPEN \
  -pwfile +DATA/ORCLDR/PASSWORD/orapworcl
```

- *Check password file*
```select * from v$passwordfile_info;```

- *Check parameter file*
```show parameter spfile;```

## 3. Copy and modify parameter file
## 4. Common Command

alter system set standby_file_management = manual scope=both;

set lines 200 pages 200
col member for a85
select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$log l, v$logfile f where l.group#=f.group# order by f.type, l.group#; 
select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$standby_log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;


SQL> alter system set db_create_online_log_dest_2='+FRA' scope=both;

System altered.

SQL> show parameter db_create_file_dest;

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
create_bitmap_area_size              integer     8388608
create_stored_outlines               string
db_create_file_dest                  string      +DATA
db_create_online_log_dest_1          string      +DATA
db_create_online_log_dest_2          string      +FRA


select distinct 'alter database clear logfile group '||group#||';' from v$logfile;

alter database clear logfile group 1;
alter database clear logfile group 2;
alter database clear logfile group 3;
alter database clear logfile group 4;
alter database clear logfile group 11;
alter database clear logfile group 12;
alter database clear logfile group 13;
alter database clear logfile group 14;
alter database clear logfile group 15;
alter database clear logfile group 16;

alter database DROP logfile group 1;
alter database DROP logfile group 2;
alter database DROP logfile group 3;
alter database DROP logfile group 4;
alter database DROP logfile group 5;
alter database DROP logfile group 6;
alter database DROP logfile group 7;


ALTER DATABASE ADD LOGFILE MEMBER '+RECOC1' TO GROUP 1;
ALTER DATABASE ADD LOGFILE MEMBER '+RECOC1' TO GROUP 2;
ALTER DATABASE ADD LOGFILE MEMBER '+RECOC1' TO GROUP 3;
ALTER DATABASE ADD LOGFILE MEMBER '+RECOC1' TO GROUP 4;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+RECOC1' TO GROUP 11;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+RECOC1' TO GROUP 12;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+RECOC1' TO GROUP 13;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+RECOC1' TO GROUP 21;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+RECOC1' TO GROUP 22;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+RECOC1' TO GROUP 23;

ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+FRA' TO GROUP 5;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+FRA' TO GROUP 6;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+FRA' TO GROUP 7;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+FRA' TO GROUP 8;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+FRA' TO GROUP 9;
ALTER DATABASE ADD STANDBY LOGFILE MEMBER '+FRA' TO GROUP 10;

ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 1 ('+DATAC1', '+RECOC1') SIZE 200M;
ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 2 ('+DATAC1', '+RECOC1') SIZE 200M;
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 3 ('+DATAC1', '+RECOC1') SIZE 200M;
ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 4 ('+DATAC1', '+RECOC1') SIZE 200M;

ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 11 ('+DATA', '+RECO') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 12 ('+DATA', '+RECO') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 13 ('+DATA', '+RECO') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 14 ('+DATA', '+RECO') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 15 ('+DATA', '+RECO') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 GROUP 16 ('+DATA', '+RECO') SIZE 200M;

ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 11 ('+DATA', '+FRA') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 12 ('+DATA', '+FRA') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 13 ('+DATA', '+FRA') SIZE 200M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 GROUP 14 ('+DATA', '+FRA') SIZE 200M;

alter system set standby_file_management = auto scope=both;

ALTER SYSTEM SET LOCAL_LISTENER='(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.58.21)(PORT=1521))' SCOPE=BOTH;

ALTER SYSTEM SET log_file_name_convert='E:\APP\ADMINQLHT\VIRTUAL\ORADATA\KTDOCSDR\ONLINELOG\','+DATAC1/KTDOCSDBX11/ONLINELOG/' SCOPE=SPFILE;
ALTER SYSTEM SET db_file_name_convert='E:\APP\ADMINQLHT\VIRTUAL\ORADATA\KTDOCSDR\','+DATAC1/KTDOCSDBX11/' SCOPE=SPFILE;

create configuration 'DG_MOBILEDB' as primary database is 'MOBILEDB' connect identifier is 'MOBILEDB';
add database 'MOBILEDBDR' as connect identifier is 'MOBILEDBDR' maintained as physical;

run {
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate channel c3 device type disk;
allocate channel c4 device type disk;
allocate channel c5 device type disk;
allocate channel c6 device type disk;
allocate channel c7 device type disk;
allocate channel c8 device type disk;
allocate channel c9 device type disk;
allocate channel c10 device type disk;
allocate channel c11 device type disk;
allocate channel c12 device type disk;
allocate channel c13 device type disk;
allocate channel c14 device type disk;
allocate channel c15 device type disk;
allocate channel c16 device type disk;
set newname for database to '+DATA';
restore database from service QLHDKTDBX11;
}

switch database to copy;


run {
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate channel c3 device type disk;
allocate channel c4 device type disk;
allocate channel c5 device type disk;
allocate channel c6 device type disk;
allocate channel c7 device type disk;
allocate channel c8 device type disk;
allocate channel c9 device type disk;
allocate channel c10 device type disk;
allocate channel c11 device type disk;
allocate channel c12 device type disk;
allocate channel c13 device type disk;
allocate channel c14 device type disk;
allocate channel c15 device type disk;
allocate channel c16 device type disk;
recover database from service QLHDKTDBX11;
}



alter database recover managed standby database cancel;
alter database recover managed standby database nodelay disconnect;


SELECT thread#, sequence#, applied, completion_time FROM v$archived_log ORDER BY sequence# asc;

LOCATION=USE_DB_RECOVERY_FILE_DEST VALID_FOR=(ALL_LOGFILES,ALL_ROLES)
 
SELECT SUM(bytes)/1024/1024/1024 AS GB_size FROM dba_data_files;

