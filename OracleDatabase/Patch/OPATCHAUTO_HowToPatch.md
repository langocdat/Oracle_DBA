# #APPLY PATCH GRID AND DB WITH OPATCHAUTO
# 1. Chuẩn bị trước khi patch
## 1.1 Tạo folder chứa file patch
[root]:
```
mkdir -p /u01/software
chown oracle:oinstall /u01/software
chmod 775 /u01/software
```

Attention: Tắt Instance trên NODE cần patch

## 1.2 Unzip file patch và OPatch
- Đảm bảo toàn bộ file OPatch trong GRID HOME và ORACLE HOME được thay thế bằng phiên bản mới
- Backup và giải nén OPATCH

[root]:
```
mv OPatch OPatch.bkp
```

- Unmount ACFS trên node thực hiện
```
[root@misdb01 ~]# export PATH=$PATH:/u01/app/19.0.0.0/grid/bin
[root@misdb01 ~]# crsctl stat res -w "TYPE = ora.acfs.type" -p | grep VOLUME
[root@misdb01 ~]# srvctl stop filesystem -d <volume device path> -n misdb01
```

## 1.3 Backup GRID_HOME, DB_HOME và oraInventory
[root]:
```
cd /u01/app/19.0.0.0
tar -pcvf grid_backup.tar grid
```

```
[root@misdb01 ~]# cd /u01/app/oracle/product/19.0.0.0
[root@misdb01 19.0.0.0]# tar -pcvf dbhome_1_backup.tar dbhome_1

[root@misdb01 ~]# cd /u01/app
[root@misdb01 app]# tar -pcvf oraInventory.tar oraInventory
```

[root]:
```
cd /u01/app
tar -pcvf oraInventory.tar oraInventory
```

## 1.4 Chạy OPatch Check Conflict
```
[oracle@misdb01 ~]$ . grid
[oracle@misdb01 ~]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/software/36233126/36233263
[oracle@misdb01 ~]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/software/36233126/36240578
[oracle@misdb01 ~]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/software/36233126/36233343
[oracle@misdb01 ~]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/software/36233126/36460248
[oracle@misdb01 ~]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -phBaseDir /u01/software/36233126/36383196

[oracle@misdb01 ~]$ cd /u01/software/36195566
[oracle@misdb01 36195566]$ $ORACLE_HOME/OPatch/opatch prereq CheckConflictAgainstOHWithDetail -ph ./
```

## 1.5 Chạy System Space Check
```
[oracle@misdb01 ~]$ . grid
[oracle@misdb01 ~]$ vi /tmp/patch_list_gihome.txt
/u01/software/36233126/36233263
/u01/software/36233126/36240578
/u01/software/36233126/36233343
/u01/software/36233126/36460248
/u01/software/36233126/36383196

[oracle@misdb01 ~]$ $ORACLE_HOME/OPatch/opatch prereq CheckSystemSpace -phBaseFile /tmp/patch_list_gihome.txt
```

## 1.6 Chạy kiểm tra phân tích tiến trình Patch
```
[root@misdb01 ~]# export PATH=$PATH:/u01/app/19.0.0.0/grid/OPatch:$PATH
[root@misdb01 ~]# cd /u01/software
[root@misdb01 software]# cd /u01/software
[root@misdb01 software]# /u01/app/19.0.0.0/grid/OPatch/opatchauto apply /u01/software/36233126 -analyze
[oracle@misdb01 ~]$ . grid
[oracle@misdb01 ~]$ cluvfy stage -pre patch
```

# 2. Thực hiện Patch
## 2.1 Patch GRID_HOME
```
[root@misdb01 ~]# export PATH=$PATH:/u01/app/19.0.0.0/grid/OPatch:$PATH
[root@misdb01 ~]# opatchauto apply /u01/software/36233126 -oh /u01/app/19.0.0.0/grid
```

## 2.2 Patch DB_HOME

- Đổi quyền thư mục /u01/software về oracle:oinstall
```
[root]: chown -R oracle:oinstall /u01/software
```

```
[root@misdb01 ~]# export PATH=$PATH:/u01/app/oracle/product/19c/dbhome_1/OPatch:$PATH
[root@misdb01 ~]# opatchauto apply /u01/software/36233126 -oh /u01/app/oracle/product/19c/dbhome_1
```

# 3. ROLLBACK
```
[root@misdb01 ~]# export PATH=$PATH:/u01/app/19.0.0.0/grid/OPatch:$PATH
[root@misdb01 ~]# opatchauto rollback /u01/software/36233126 -oh /u01/app/19.0.0.0/grid
```

# 4. PATCH JDK GRID (nếu có)
```
[oracle@misdb01 ~]$ . grid
[oracle@misdb01 ~]$ chmod -R 755 $ORACLE_HOME/jdk

[root@misdb01 ~]# /u01/app/19.0.0.0/grid/OPatch/opatchauto apply /u01/software/36195566 -oh /u01/app/19.0.0.0/grid
```

# 5. MOUNT lại ACFS sau khi PATCH (nếu có)
```
[root@misdb01 ~]# export PATH=$PATH:/u01/app/19.0.0.0/grid/bin
[root@misdb01 ~]# crsctl stat res -w "TYPE = ora.acfs.type" -p | grep VOLUME
[root@misdb01 ~]# srvctl start filesystem -d <volume device path> -n misdb01
```

# 6. Chạy Datapatch (chỉ áp dụng khi PATCH DB HOME)
- Thực hiện khi Patch Instance cuối cùng và bật toàn bộ Instance
```
[oracle@misdb03 ~]$ . oracle
[oracle@misdb03 ~]$ cd $ORACLE_HOME/OPatch
[oracle@misdb03 OPatch]$ ./datapatch -verbose -db ...
```

# 7. Phương án ROLLBACK và thay thế HOME bằng bản backup
```
[root@misdb01 ~]$ cd /u01/app/oracle/product/19.0.0.0
[root@misdb01 19.0.0.0]$ mv dbhome_1 dbhome_1_bk
[root@misdb01 19.0.0.0]$ tar -pxvf dbhome_1_backup.tar
```
