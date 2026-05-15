# Step 1: Tạo ASM DISKGROUP
[root]$
  ```
  udevadm info --query=all --name=/dev/vdb
  udevadm info --query=all --name=/dev/vdc
  lsblk
  ```
[root]$ vi /etc/udev/rules.d/99-oracle-asm.rules
  ```
  SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_PATH_TAG}=="pci-0000_05_00_0", \
      SYMLINK+="ASM_DATA", OWNER="grid", GROUP="asmadmin", MODE="0660"
  
  SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_PATH_TAG}=="pci-0000_06_00_0", \
      SYMLINK+="ASM_FRA", OWNER="grid", GROUP="asmadmin", MODE="0660"
  ```
[root]$ reload
  ```
  udevadm control --reload-rules
  udevadm trigger
  ls -ln /dev/ASM*
  ```

# Step 2: vi /home/grid/grid.rsp
  ```
  oracle.install.responseFileVersion=/oracle/install/rspfmt_crsinstall_response_schema_v19.0.0
  INVENTORY_LOCATION=/u01/app/oraInventory
  oracle.install.option=HA_CONFIG
  ORACLE_BASE=/u01/app/grid
  oracle.install.asm.OSDBA=asmdba
  oracle.install.asm.OSOPER=asmoper
  oracle.install.asm.OSASM=asmadmin
  oracle.install.crs.config.ClusterConfiguration=STANDALONE
  oracle.install.crs.config.configureAsExtendedCluster=false
  oracle.install.crs.config.clusterName=gridcluster
  oracle.install.crs.config.gpnp.scanName=
  oracle.install.crs.config.gpnp.scanPort=
  oracle.install.crs.config.clusterNodes=
  oracle.install.crs.config.networkInterfaceList=eth0:10.62.128.0:1
  oracle.install.asm.diskGroup.name=DATA
  oracle.install.asm.diskGroup.redundancy=EXTERNAL
  oracle.install.asm.diskGroup.AUSize=4
  oracle.install.asm.diskGroup.disks=/dev/ASM_DATA
  oracle.install.asm.diskGroup.diskDiscoveryString=/dev/ASM*
  oracle.install.asm.monitorPassword=oracle
  oracle.install.asm.SYSASMPassword=oracle
  oracle.install.crs.rootconfig.executeRootScript=false
  ```
# Step 3: Chạy lệnh thực thi
[grid]$ 
  ```
  /u01/app/19c/grid/gridSetup.sh -silent -responseFile /home/grid/grid.rsp
  ```
# Step 4: Chạy lệnh với user root
[root]$
  ```
   1. /u01/app/oraInventory/orainstRoot.sh
   2. /u01/app/19c/grid/root.sh
  ```
# Step 5: Chạy lệnh với user grid
[grid]$
  ```
  /u01/app/19c/grid/gridSetup.sh -executeConfigTools -responseFile /home/grid/grid.rsp -silent
  ```
# Step 6: Tạo diskgroup FRA
[grid]$ sqlplus / as sysasm
  ```
  CREATE DISKGROUP FRA EXTERNAL REDUNDANCY DISK '/dev/ASM_FRA' ATTRIBUTE 'compatible.asm'='19.0.0.0.0';
  ```
