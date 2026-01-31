# Prepare 
1. Install software
## Step 1: Prepare path
  ```
  mkdir -p /u01/app/oracle/fast_recovery
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


