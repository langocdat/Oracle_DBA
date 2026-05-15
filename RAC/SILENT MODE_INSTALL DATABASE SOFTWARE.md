# Step 1: Create file db_install.rsp
[oracle]$ vi /home/oracle/db_install.rsp
  ```
  oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v12.2.0
  oracle.install.option=INSTALL_DB_SWONLY
  ORACLE_HOSTNAME=SvC-odax11-db06
  UNIX_GROUP_NAME=oinstall
  INVENTORY_LOCATION=/u01/app/oraInventory
  ORACLE_HOME=/u01/app/oracle/product/12c/dbhome_1
  ORACLE_BASE=/u01/app/oracle
  oracle.install.db.InstallEdition=EE
  oracle.install.db.OSDBA_GROUP=dba
  oracle.install.db.OSOPER_GROUP=dba
  oracle.install.db.OSBACKUPDBA_GROUP=dba
  oracle.install.db.OSDGDBA_GROUP=dba
  oracle.install.db.OSKMDBA_GROUP=dba
  oracle.install.db.OSRACDBA_GROUP=dba
  ```
# Step 2: Run command
[oracle]$ cd /home/oracle/database <Đường dẫn tới thư mục chứa bộ cài đặt oracle database>
[oracle]$ ```/home/oracle/database/./runInstaller -silent -responseFile /home/oracle/db_install.rsp```
[root]$ ```/u01/app/oracle/product/12c/dbhome_1/root.sh```
