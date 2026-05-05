# Step 1: tạo file dbca.rsp
 File name: dbca_silent.rsp
```
responseFileVersion=/oracle/assistants/rspfmt_dbca_response_schema_v12.2.0
gdbName=mobiledb
sid=mobiledb
databaseConfigType=RAC
policyManaged=false
createServerPool=false
force=false
createAsContainerDatabase=false
nodelist=dc-exax11-db01,dc-exax11-db02
templateName=/u01/app/oracle/product/19.0.0.0/dbhome_1/assistants/dbca/templates/General_Purpose.dbc
runCVUChecks=TRUE
datafileDestination=+DATAC1/{DB_UNIQUE_NAME}/
recoveryAreaDestination=+RECOC1
recoveryAreaSize=102400
redoLogFileSize=200
storageType=ASM
diskGroupName=+DATAC1/{DB_UNIQUE_NAME}/
recoveryGroupName=+RECOC1
characterSet=AL32UTF8
variables=ORACLE_BASE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1/,DB_UNIQUE_NAME=mobiledb,ORACLE_BASE=/u01/app/oracle,PDB_NAME=,DB_NAME=mobiledb,ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1/,SID=mobiledb
initParams=mobiledb1.undo_tablespace=UNDOTBS1,mobiledb2.undo_tablespace=UNDOTBS2,sga_target=20480MB,db_block_size=8192BYTES,cluster_database=true,family:dw_helper.instance_mode=read-only,nls_language=AMERICAN,dispatchers=(PROTOCOL=TCP) (SERVICE=orcldcXDB),diagnostic_dest={ORACLE_BASE},remote_login_passwordfile=exclusive,db_create_file_dest=+DATAC1/{DB_UNIQUE_NAME}/,audit_file_dest={ORACLE_BASE}/admin/{DB_UNIQUE_NAME}/adump,processes=300,pga_aggregate_target=5120MB,mobiledb1.thread=1,mobiledb2.thread=2,nls_territory=AMERICA,local_listener=-oraagent-dummy-,db_recovery_file_dest_size=102400MB,open_cursors=300,log_archive_format=%t_%s_%r.dbf,db_domain=localdomain,compatible=19.0.0,db_name=mobiledb,mobiledb1.instance_number=1,mobiledb2.instance_number=2,db_recovery_file_dest=+RECOC1,audit_trail=db
memoryPercentage=40
databaseType=MULTIPURPOSE
sysPassword=oracle4U
systemPassword=oracle4U
```

# Step 2: Tạo database
[oracle]$

```
/u01/app/oracle/product/19c/dbhome_1/bin/dbca -silent -debug -createDatabase -responseFile /u01/app/oracle/product/19c/dbhome_1/assistants/dbca/dbca_silent.rsp
```
