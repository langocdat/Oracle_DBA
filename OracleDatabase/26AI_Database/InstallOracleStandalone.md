# 1. Overview
- OS: Linux 8.10
  ```https://download.oracle.com/otn/linux/oracle26ai/2326100/oracle-ai-database-ee-26ai-1.0-1.el8.x86_64.rpm```
- GRID: LINUX.X64_2326100_grid_home.zip
  ```https://download.oracle.com/otn/linux/oracle26ai/2326100/LINUX.X64_2326100_grid_home.zip```
- Database: LINUX.X64_2326100_db_home.zip
  ```https://download.oracle.com/otn/linux/oracle26ai/2326100/LINUX.X64_2326100_db_home.zip```

Link download: https://www.oracle.com/database/technologies/oracle26ai-linux-downloads.html 

# 2. Install LINUX 8.10, chuẩn bị môi trường
## 2.1 Configure hostname
[root]$ ```hostnamectl set-hostname srv26AI.localdomain```

## 2.2 Configure IP
[root]$ ```nmcli con show```

[root]$ ```vi /etc/sysconfig/network-scripts/ifcfg-...```

| STT | NAME | IP | 
| :-- | :-- | :-- |
| 1 | Host Only | 192.168.58.60

## 2.3 Install Package
[root]$ 
  ```
  yum update -y  
  yum list | grep 26ai -i
  yum install oracle-ai-database-preinstall-26ai.x86_64 -y
  yum list | grep oracleasm -i
  yum install kmod-redhat-oracleasm.x86_64 -y
  ```
## 2.4 Create path
[root]$ 
  ```
  mkdir -p /u01/app/oracle/product/26AI/dbhome_1
  mkdir -p /u01/app/26AI/grid
  mkdir -p /u01/app/grid
  ```
## Step 2.5: Create group
[root]$ 
  ```
  groupadd asmdba
  groupadd asmoper
  groupadd asmadmin

  ==>> Đổi tên asmopers thành asmoper: groupmod -n asmoper asmopers
  ==>> Check các group hiện có: cat /etc/group hoặc getent group
  ```
## Step 2.6: Create User grid + oracle
  [bash_root]$ 
  ```
  passwd oracle
  -->> double fill password
  useradd -g oinstall -G asmadmin,asmdba,asmoper,dba grid
  passwd grid
  -->> double fill password

  usermod -g oinstall -G dba,oper,backupdba,dgdba,kmdba,asmdba,asmoper,asmadmin,racdba oracle
  usermod -g oinstall -G dba,oper,backupdba,dgdba,kmdba,asmdba,asmoper,asmadmin,racdba grid

  ==>> Check nhóm quyền của user: id <user>. Ex: id grid
  ==>> Add theem group cho user: usermod -aG asmadmin,asmdba,asmoper grid

  chown -R grid:oinstall /u01
  chown -R oracle:oinstall /u01/app/oracle
  ```
## Step 2.7: Create enviroment profile

  [bash_grid]$ ```vi .bash_profile```
  ```  
  export ORACLE_SID=+ASM
  export ORACLE_HOME=/u01/app/26AI/grid
  export BASE_PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin
  export PATH=$ORACLE_HOME/bin:$BASE_PATH
  export LD_LIBRARY_PATH=$ORACLE_SID/lib:/lib:/usr/lib
  export CLASSPATH=$ORACLE_SID/JRE:$ORACLE_SID/jlib:$ORACLE_SID/rdbms/jlib
  ```

  [bash_oracle]$ ```vi .bash_profile```
  ```  
  export TMP=/tmp
  export TMPDIR=$TMP
  export ORACLE_BASE=/u01/app/oracle
  export DB_HOME=$ORACLE_BASE/product/26AI/dbhome_1
  export ORACLE_HOME=$DB_HOME
  export ORACLE_SID=orcl
  export ORACLE_TERM=xterm
  export BASE_PATH=/usr/sbin:$PATH
  export PYTHONHOME=/home/oracle/python
  export PATH=$PYTHONHOME/bin:$ORACLE_HOME/bin:$BASE_PATH
  export LD_LIBRARY_PATH=$PYTHONHOME/lib:$ORACLE_HOME/lib:/lib:/usr/lib
  export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
  export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
  ```
## Step 2.7: Shutdown machine and add disk

1. Shutdown machine
2. Add disk
3. Start machine

---

# 3. Install GRID
## 3.1: Tải bộ cài đặt grid và oracle
```
Đường dẫn chứa bộ cài đặt grid: /home/grid/
--> giải nén (dùng user grid): unzip /u01/app/26AI/grid
Đường dẫn chứa bộ cài đặt oracle: /home/oracle
--> giải nén (dùng user oracle): unzip /u01/app/oracle/product/26AI/dbhome_1
```
## 3.2: Configure ASM
### Use Udev

1. Create file .rules

- Path: /etc/udev/rules.d/
  
- Example:
  
  [bash_root]: ```vi 99-oracle-asm.rules```
  
- Contents:
	```
	SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="VBOX_HARDDISK_VBc3e93220-8251670d", \
		SYMLINK+="ASM_DATA", OWNER="grid", GROUP="asmadmin", MODE="0660"
	SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="VBOX_HARDDISK_VB6288da08-f952843a", \
		SYMLINK+="ASM_FRA", OWNER="grid", GROUP="asmadmin", MODE="0660"
	```
2. Query
	[bash_root]:
	```
	lsblk
	fdisk -l
	udevadm info --query=all --name=/dev/sdb
	```  
3. Reload
	[bash_root]:
	```
	udevadm control --reload-rules && udevadm trigger
	ls -ln /dev/ASM*
	udevadm info --query=all --name=/dev/ASM_DATA | grep ID_SERIAL
	udevadm info --query=all --name=/dev/ASM_FRA | grep ID_SERIAL
	```
	 
	```
	[root@srvdc rules.d]# ls -ln /dev/ASM*
	lrwxrwxrwx. 1 0 0 3 Jan 22 21:59 /dev/ASM_DATA -> sdb
	lrwxrwxrwx. 1 0 0 3 Jan 22 21:59 /dev/ASM_FRA -> sdc
	```
### Use ORACLEASM
Tham khảo https://github.com/langocdat/Oracle_DBA/blob/main/RAC/ConfigureRAC_2Node.txt

## 3.3: Install GRID
- [bash_grid]:
  ```
  cd /u01/app/26AI/grid
  export DISPLAY=192.168.58.1:0.0
  ./gridSetup.sh
  ```
  
  <img width="800" height="281" alt="image" src="https://github.com/user-attachments/assets/a542696e-b0b3-4209-a6d1-018036f1b1c6" />

  <img width="804" height="333" alt="image" src="https://github.com/user-attachments/assets/2c7f74db-e393-46e9-b907-cdf3418dfb89" />

  <img width="790" height="267" alt="image" src="https://github.com/user-attachments/assets/1fde8423-cbf6-4042-a911-ea50828f4587" />

  <img width="789" height="199" alt="image" src="https://github.com/user-attachments/assets/f23a1d8f-c502-43f4-bc44-590e45dd6226" />

  <img width="796" height="242" alt="image" src="https://github.com/user-attachments/assets/c5687e0e-b66b-409a-9de9-d9c536d65eed" />

  <img width="799" height="257" alt="image" src="https://github.com/user-attachments/assets/7f5a6b5e-e30b-4211-a080-d783b1f5f50b" />

  <img width="801" height="441" alt="image" src="https://github.com/user-attachments/assets/ba2ff581-1446-4d0f-bb19-6f12107c9e26" />


## 3.4: Create DISKGROUP
- [bash_grid]:
	```
	cd /u01/app/26AI/grid
	export DISPLAY=192.168.58.1:0.0
	asmca
	```
 	
	

  





# 4. Install Database
# 5. Install AI to Database
Tổng quát:
- Cài đặt Python
- Get mô hình AI dạng Text Embedding
- Đóng gói thành file ONNX
- Import file ONNX vào Database
