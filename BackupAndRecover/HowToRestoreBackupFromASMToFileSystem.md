# Prepare 
1. Install software
## Step 1: Prepare path
  ```
  mkdir -p /u01/app/oracle/fast_recovery_area
  mkdir -p /u01/app/oracle/oradata/ORCL
  mkdir -p /u01/app/oracle/admin/ORCL/adump
  ```
## Step 2: Edit parameter file init<SID>.ora
  ```
  orcl.__data_transfer_cache_size=0
  orcl.__db_cache_size=1275068416
  orcl.__inmemory_ext_roarea=0
  orcl.__inmemory_ext_rwarea=0
  orcl.__java_pool_size=0
  orcl.__large_pool_size=16777216
  orcl.__oracle_base='/u01/app/oracle'#ORACLE_BASE set from environment
  orcl.__pga_aggregate_target=637534208
  orcl.__sga_target=1895825408
  orcl.__shared_io_pool_size=100663296
  orcl.__shared_pool_size=486539264
  orcl.__streams_pool_size=0
  orcl.__unified_pga_pool_size=0
  *.audit_file_dest='/u01/app/oracle/admin/ORCL/adump'
  *.audit_trail='db'
  *.compatible='19.0.0'
  *.control_files='/u01/app/oracle/oradata/ORCL/control01.ctl','/u01/app/oracle/fast_recovery_area/ORCL/control02.ctl'
  *.db_block_size=8192
  *.db_domain='localdomain'
  *.db_name='orcl'
  *.db_recovery_file_dest='/u01/app/oracle/fast_recovery_area'
  *.db_recovery_file_dest_size=3900m
  *.diagnostic_dest='/u01/app/oracle'
  *.dispatchers='(PROTOCOL=TCP) (SERVICE=orclXDB)'
  family:dw_helper.instance_mode='read-only'
  *.local_listener='-oraagent-dummy-'
  *.log_archive_format='%t_%s_%r.dbf'
  *.nls_language='AMERICAN'
  *.nls_territory='AMERICA'
  *.open_cursors=300
  *.pga_aggregate_target=599m
  *.processes=300
  *.remote_login_passwordfile='exclusive'
  *.sga_target=1796m
  orcl.undo_tablespace='UNDOTBS1'
  ```
## Step 3: Start nomount with pfile and create spfile

  SQL> ```startup nomount pfile = '/u01/app/oracle/product/19c/dbhome_1/dbs/initORCL.ora';```

  SQL> ```create spfile from pfile;```

## Step 4: Restart with spfile

  SQL> ```startup nomount;```

## Step 5: Restore controlfile

  RMAN> ```restore controlfile from '/home/oracle/backup/ctl.bk';```

## Step 6: Mount database

  RMAN> ```alter database mount;```

## Step 7: Catalog backup

  RMAN> ```catalog start with '/home/oracle/backup';```

## Step 8: Run scripts restore

  (bash_oracle):
  ```
  rman target / checksyntax @'/home/oracle/scripts_restore_and_recovery.rman'
  nohup rman target / @'/home/oracle/scripts_restore_and_recovery.rman' log='/home/oracle/scripts_restore_and_recovery.log' &
  ```
  ```
  run {
  allocate channel d1 device type disk;
  allocate channel d2 device type disk;
  allocate channel d3 device type disk;
  allocate channel d4 device type disk;
  allocate channel d5 device type disk;
  SET NEWNAME FOR DATABASE TO '/u01/app/oracle/oradata/ORCL/%b'; 
  SET NEWNAME FOR tempfile 1 TO '/u01/app/oracle/oradata/ORCL/%b';
  SET UNTIL SEQUENCE 8; ---rman: LIST BACKUP OF ARCHIVELOG ALL; max(sequence) + 1
  restore database;
  switch datafile all;
  switch tempfile all;
  RECOVER DATABASE;
  }
  ```
### How to Check max sequence archivelog 
  <img width="1004" height="378" alt="image" src="https://github.com/user-attachments/assets/d997c686-1711-44d9-94fc-805dd767d218" />
  
  max sequence + 1

## Step 9: Open database with mode resetlogs

  RMAN,SQL> ```alter database open resetlogs;```
