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
<img width="1392" height="204" alt="image" src="https://github.com/user-attachments/assets/21b8db0d-d7f4-4345-991d-f94007192026" />

<img width="998" height="387" alt="image" src="https://github.com/user-attachments/assets/2b5d9434-6464-40b1-a3f5-e2145d71b1e7" />

<img width="1002" height="454" alt="image" src="https://github.com/user-attachments/assets/eeb33923-d392-4282-8589-6d7738b00c63" />

<img width="1000" height="413" alt="image" src="https://github.com/user-attachments/assets/80cde290-9078-4ec4-8919-e85ca13c1af2" />

<img width="997" height="393" alt="image" src="https://github.com/user-attachments/assets/9cd62a85-f254-44c7-8730-504f6bbbe26b" />

<img width="1001" height="598" alt="image" src="https://github.com/user-attachments/assets/ffbd4e78-09ad-488f-a697-10caa473ee4e" />

*How to fix*
```
[root@srv2 app]# mkdir -p /u01/app/19c/grid
[root@srv2 app]# chown -R grid:oinstall /u01/app/19c/grid/
[root@srv2 app]# chmod -R 775 /u01/app/19c
```
<img width="1001" height="792" alt="image" src="https://github.com/user-attachments/assets/29959b86-0836-413a-a7b9-357a87470f9c" />

<img width="744" height="314" alt="image" src="https://github.com/user-attachments/assets/86e5db78-1af8-4b2f-af38-2be2c6e5c1fe" />

<img width="1575" height="808" alt="image" src="https://github.com/user-attachments/assets/135c2ec7-357e-4768-9c5f-be49ed5bbd9d" />









