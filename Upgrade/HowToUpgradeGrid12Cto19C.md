# Decribe
- Rac 2 node
- Upgrade version 12C to 19C and apply patch 19.30

# Perform
## Step 1: Prerequire
### 1.1 Shutdown all the database run on the both node.
### 1.2 Get file to the node 1
```
[root@srv1 ~]# cd /u01/software/
[root@srv1 software]# ll
total 6862604
-rw-r--r--. 1 root root 4065210500 Oct 10 21:06 p38629535_190000_Linux-x86-64.zip
-rw-r--r--. 1 root root   72896144 Oct 10 21:05 p6880880_190000_Linux-x86-64.zip
-rw-r--r--. 1 root root 2889184573 Oct 10 21:05 V982068-01_grid.zip
```

## Step 2: Backup in the both node
*Use the root user*
- Backup /u01/app/oraInventory
```
[root@srv1 app]# cd /u01/app
[root@srv1 app]# ls
12c  grid  oracle  oraInventory
[root@srv1 app]# tar -pcvf oraInventory.tar oraInventory/
```
- Backup /u01/app/12c/grid
```
[root@srv1 app]# cd 12c/
[root@srv1 12c]# pwd
/u01/app/12c
[root@srv1 12c]# ls
grid
[root@srv1 12c]# tar -pcvf grid.tar grid/
```
- Backup /u01/app/grid
```
[root@srv1 app]# cd /u01/app
[root@srv1 app]# ls
12c  grid  oracle  oraInventory
[root@srv1 app]# tar -pcvf grid.tar grid/
```
- Backup /u01/app/oracle/product/12c/dbhome_1
```
[root@srv1 12c]# pwd
/u01/app/oracle/product/12c
[root@srv1 12c]# ls
dbhome_1
[root@srv1 12c]# tar -pcvf dbhome_1.tar dbhome_1/
```

## Step 3: Create new 19C GI_HOME and unzip software + OPatch ulities
- Create new 19c GI_HOME
```
[root@srv1 ~]# mkdir -p /u01/app/19c/grid
[root@srv1 ~]# chown -R grid:oinstall /u01/app/19c/grid/
```
- Unzip new 19C GI software
```
[root@srv1 ~]# cd /u01/app/19c/grid/
[root@srv1 grid]# pwd
/u01/app/19c/grid
[root@srv1 grid]# unzip /u01/software/V982068-01_grid.zip
[root@srv1 grid]# chown -R grid:oinstall /u01/app/19c/grid/
[root@srv1 grid]# rm -rf OPatch
[root@srv1 grid]# unzip /u01/software/p6880880_190000_Linux-x86-64.zip
[root@srv1 grid]# chown -R grid:oinstall /u01/app/19c/grid/OPatch
```
*Install the new OPatch utilities on both node*

## Step 4: Kiểm tra trạng thái nâng cấp bằng tool Cluster Verification Utility (CVU)
```
[grid@srv1 ~]$ cd /u01/app/19c/grid
[grid@srv1 grid]$ ./runcluvfy.sh stage -pre crsinst -upgrade -rolling -src_crshome /u01/app/12c/grid -dest_crshome /u01/app/19c/grid -dest_version 19.0.0.0.0 -fixup -verbose
```
<img width="1242" height="636" alt="image" src="https://github.com/user-attachments/assets/6055bd00-9310-48ac-a47c-52b0e6ebb2da" />

# Step 5: Apply patch and Upgrade GI
```
[grid@srv1 software]$ cd /u01/app/19c/grid/
[grid@srv1 software]$ export DISPLAY=192.168.58.1:0.0
[grid@srv1 grid]$ ./gridSetup.sh -applyRU /u01/software/38629535/
Preparing the home to patch...
Applying the patch /u01/software/38629535/...
Successfully applied the patch.
The log can be found at: /u01/app/oraInventory/logs/GridSetupActions2026-06-25_11-53-10AM/installerPatchActions_2026-06-25_11-53-10AM.log
Launching Oracle Grid Infrastructure Setup Wizard...
```
