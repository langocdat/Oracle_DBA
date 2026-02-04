# How to check current control_file

SQL> 
  ```
  Show parameter control_files;
  Select * from v$controlfile;
  ```

# How to add controlfile
## Step 1: Alter system
  SQL>
  ```
  Alter system set control_files = '/u01/app/oracle/oradata/ORCL/control01.ctl', '/u01/app/oracle/fast_recovery_area/ORCL/control02.ctl', '/u01/app/oracle/oradata/ORCL/control03.ctl' scope=spfile;
  ```
## Step 2: Shutdown database
  SQL> ```shutdown immediate;```
## Step 3: Copy control file
  SQL> ``` ! cp /u01/app/oracle/oradata/ORCL/control01.ctl /u01/app/oracle/oradata/ORCL/control03.ctl```

  > Or copy in new session

## Step 4: Start database and check again
  
  SQL> 
  ```
  Show parameter control_files;
  Select * from v$controlfile;
  ```
