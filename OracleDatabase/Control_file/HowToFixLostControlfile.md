# Show controlfile

  SQL>
  ```
  Show parameter control_files;
  Select * from controlfile;
  ```

## 1. Trường hợp mất 1 control file trên OS vật lý
### Step 1: 

  SQL> ```shutdown abort;```
  
### Step 2: copy control1 tạo thành file control2

  Bash_Oracle#: ```cp control1.ctl control2.ctl```
  
### Step 3: startup Database
   SQL>: ```startup nomount -> alter database mount -> alter database open;```

## 2. Trường hợp mất tất cả các control file trên OS vật lý
> Attention: Start nomount

### Case 1: sử dụng bản backup

  #### Step 1:

  RMAN> 
  ```
  restore controlfile from autobackup;
  RESTORE CONTROLFILE FROM '/backup/ctrlfile.bkp';
  ```

  #### Step 2: 
  
  (rman/sql): ```alter database mount;```
  
  #### Step 3: 
  
  (rman): ```recover database;```
  
  #### Step 4: 
  
  (rman/sql): ```alter database open;```

### Case 2: Tạo lại control file sử dụng scripts

#### Step 1: 

> (bash):  ls -lh /u01/app/oracle/oradata/ORCL/*.dbf  --> list các file dbf

> hoặc Insance Mount/Open: select name from v$datafile;

#### Step 2: gen scripts create_control_file.sql
  ```
          CREATE CONTROLFILE REUSE DATABASE "ORCL" RESETLOGS ARCHIVELOG
              MAXLOGFILES 16
              MAXLOGMEMBERS 3
              MAXDATAFILES 200
              MAXINSTANCES 1
              MAXLOGHISTORY 292
          LOGFILE
            GROUP 1 '/u01/app/oracle/oradata/ORCL/redo01.log' SIZE 200M,
            GROUP 2 '/u01/app/oracle/oradata/ORCL/redo02.log' SIZE 200M,
            GROUP 3 '/u01/app/oracle/oradata/ORCL/redo03.log' SIZE 200M
          DATAFILE
           '/u01/app/oracle/oradata/ORCL/system01.dbf',
          '/u01/app/oracle/oradata/ORCL/sysaux01.dbf',
          '/u01/app/oracle/oradata/ORCL/undotbs01.dbf',
          '/u01/app/oracle/oradata/ORCL/pdbseed/system01.dbf',
          '/u01/app/oracle/oradata/ORCL/pdbseed/sysaux01.dbf',
          '/u01/app/oracle/oradata/ORCL/users01.dbf',
          '/u01/app/oracle/oradata/ORCL/pdbseed/undotbs01.dbf',
          '/u01/app/oracle/oradata/ORCL/orclpdb/system01.dbf',
          '/u01/app/oracle/oradata/ORCL/orclpdb/sysaux01.dbf',
          '/u01/app/oracle/oradata/ORCL/orclpdb/undotbs01.dbf',
          '/u01/app/oracle/oradata/ORCL/orclpdb/users01.dbf';
  ```
#### Step 3: Startup nomount;
#### Step 4: run scripts create_control_file.sql

SQL>  ```@create_control_file.sql```

#### Step 5: 

SQL>  ``` alter database open resetlogs;```
`
Nếu hệ thống báo cần recover thì làm các bước sau:
   Step 5.1:
    - (rman): recover database;
   Step 5.2:
    - (rman/sql): alter database open resetlogs;
`
