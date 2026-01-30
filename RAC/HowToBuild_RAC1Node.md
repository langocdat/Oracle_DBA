# ***CONFIGURATION SYSTEM***

## Step 1: Configuration hostname

  [bash_root_dc]: ```hostnamectl set-hostname srvdc.localdomain```
  
  [bash_root_dr]: ```hostnamectl set-hostname srvdr.localdomain```
  
## Step 2: Configuration IP

  [bash_root_dc_dr]: ```nmcli con show```
  
  [bash_root_dc_dr]: ```vi /etc/sysconfig/network-scripts/ifcfg-...```
  
  | STT | NAME | DC | DR |
  | :-- | :-- | :-- | :--|
  | 1 | Host Only | 192.168.58.11 | 192.168.58.12 |
  | 2 | Internal | 192.168.59. 11 | 192.168.59.12 |
  | 3 | NAT | | |  

## Step 3: Configure /etc/hosts

  [bash_root_dc_dr]: ```vi /etc/hosts```
  ```
  127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
  ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
  # Host-only
  192.168.58.11 srvdc.localdomain srvdc
  192.168.58.12 srvdr.localdomain srvdr
  # Private
  192.168.59.11 srvdc-priv.localdomain srvdc-priv
  192.168.59.12 srvdr-priv.localdomain srvdr-priv
  # Virtual IP
  192.168.58.13 srvdc-vip.localdomain srvdc-vip
  192.168.58.14 srvdr-vip.localdomain srvdr-vip
  # SCAN
  192.168.58.15 srvdc-scan.localdomain srvdc-scan
  192.168.58.16 srvdc-scan.localdomain srvdc-scan
  192.168.58.17 srvdc-scan.localdomain srvdc-scan
  192.168.58.18 srvdr-scan.localdomain srvdr-scan
  192.168.58.19 srvdr-scan.localdomain srvdr-scan
  192.168.58.20 srvdr-scan.localdomain srvdr-scan  
  # DNS
  192.168.58.21 dnsss1.localdomain dnsss1
  192.168.58.22 dnsss2.localdomain dnsss2
```

## Step 4: Install package

  [bash_root_dc_dr]: 
```
  yum update -y  
  yum list | grep 19c -i
  yum install oracle-database-preinstall-19c.x86_64 -y
  yum list | grep oracleasm -i
  yum install oracleasm-support.x86_64 -y
```
## Step 5: Off firewall and enable chrony

  [bash_root_dc_dr]:
``` 
  systemctl stop firewalld.service
  systemctl disable firewalld.service
  yum install chronyd.service
  systemctl enable chronyd.service
  systemctl restart chronyd.service
  systemctl status chronyd
  chronyc tracking
  chronyc sources
  chronyc -a 'burst 4/4'
  chronyc -a makestep
```

## Step 6: Create path

  [bash_root_dc_dr]: 
  ```
  mkdir -p /u01/app/oracle/product/19c/dbhome_1
  mkdir -p /u01/app/19c/grid
  mkdir -p /u01/app/grid
```
## Step 7: Create group

  [bash_root_dc_dr]: 
```
  groupadd asmdba
  groupadd asmoper
  groupadd asmadmin

  ==>> Đổi tên asmopers thành asmoper: groupmod -n asmoper asmopers
  ==>> Check các group hiện có: cat /etc/group hoặc getent group
```
## Step 8: Create User grid + oracle

  [bash_root_dc_dr]: 
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
  chown -R oracle:oinstll /u01/app/oracle
```
## Step 9: Create enviroment profile

  [bash_grid_dc_dr]: ```vi .bash_profile```
```  
export ORACLE_SID=+ASM
export ORACLE_HOME=/u01/app/19c/grid
export BASE_PATH=/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin
export PATH=$ORACLE_HOME/bin:$BASE_PATH
export LD_LIBRARY_PATH=$ORACLE_SID/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_SID/JRE:$ORACLE_SID/jlib:$ORACLE_SID/rdbms/jlib
```
  [bash_oracle_dc_dr]: ```vi .bash_profile```
```  
export TMP=/tmp
export TMPDIR=$TMP
export ORACLE_BASE=/u01/app/oracle
export DB_HOME=$ORACLE_BASE/product/19c/dbhome_1
export ORACLE_HOME=$DB_HOME
export ORACLE_SID=orcldc /orcldr
export ORACLE_TERM=xterm
export BASE_PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$BASE_PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
```
## Step 10: Shutdown machine and add disk

1. Shutdown machine
2. Add disk
3. Start machine

---

# ***INSTALL GRID AND ORACLE SOFTWARE***
## Step 1: Tải bộ cài đặt grid và oracle cho DC và DR
```
Đường dẫn chứa bộ cài đặt grid: /home/grid/
--> giải nén (dùng user grid): unzip /u01/app/19c/grid
Đường dẫn chứa bộ cài đặt oracle: /home/oracle
--> giải nén (dùng user oracle): unzip /u01/app/oracle/product/19c/dbhome_1
```
## Step 2: Configure ASM
- Thực hiện trên cả DC và DR
### Use Udev

1. Create file .rules

- Path: /etc/udev/rules.d/
  
- Example:
  
  [bash_root]: ```vi 99-oracle-asm.rules```
  
- Contents:
	```
	SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="VBOX_HARDDISK_VB1cd4c971-16092b15", \
		SYMLINK+="ASM_OCR", OWNER="grid", GROUP="asmadmin", MODE="0660"
	SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="VBOX_HARDDISK_VB5e9d7b3d-3af39317", \
		SYMLINK+="ASM_DATA", OWNER="grid", GROUP="asmadmin", MODE="0660"
	SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="VBOX_HARDDISK_VBf434ef6f-43e0a9c7", \
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
 	udevadm info --query=all --name=/dev/ASM_OCR | grep ID_SERIAL
	udevadm info --query=all --name=/dev/ASM_DATA | grep ID_SERIAL
	udevadm info --query=all --name=/dev/ASM_FRA | grep ID_SERIAL
	```
 	```text
  	[root@srvdc rules.d]# ls -ln /dev/ASM*
	lrwxrwxrwx. 1 0 0 3 Jan 22 21:59 /dev/ASM_DATA -> sdb
	lrwxrwxrwx. 1 0 0 3 Jan 22 21:59 /dev/ASM_FRA -> sdc
  	```
### Use ORACLEASM
Tham khảo https://github.com/langocdat/Oracle_DBA/blob/main/RAC/ConfigureRAC_2Node.txt
## Step 3: Install GRID

- [bash_grid]:
  ```
  cd /u01/app/19c/grid
  export DISPLAY=192.168.58.1:0.0
  ./gridSetup.sh
  ```

<img width="1001" height="345" alt="image" src="https://github.com/user-attachments/assets/9256e97e-6d2e-4aae-982d-c2b2c27db9e3" />

<img width="1001" height="462" alt="image" src="https://github.com/user-attachments/assets/4e36bfb6-3304-4c4a-9d03-f18fe3a2dd41" />

<img width="1001" height="329" alt="image" src="https://github.com/user-attachments/assets/fdf541a4-cdb0-4654-b48e-6db7b3506d13" />

<img width="1001" height="266" alt="image" src="https://github.com/user-attachments/assets/e5ff0797-3efd-4b79-b166-c3a33788b73d" />

<img width="1001" height="350" alt="image" src="https://github.com/user-attachments/assets/23c43ff3-439b-40b1-b766-058f7043c98e" />

<img width="1001" height="339" alt="image" src="https://github.com/user-attachments/assets/d27272e9-90ad-49cd-b105-a207c314abdd" />

<img width="1001" height="367" alt="image" src="https://github.com/user-attachments/assets/33cd3d56-748a-4ec1-acc0-43cb04fdb1f7" />

<img width="1001" height="551" alt="image" src="https://github.com/user-attachments/assets/68826fd7-dd94-405a-bdee-ea1839f8e450" />

<img width="1001" height="369" alt="image" src="https://github.com/user-attachments/assets/42a37427-2919-434c-a984-4f5dd8499b82" />

<img width="1001" height="426" alt="image" src="https://github.com/user-attachments/assets/e3f9a9db-d212-4750-bd5a-2f6bb86267c4" />

<img width="1001" height="469" alt="image" src="https://github.com/user-attachments/assets/4ab56f36-6c1a-44b2-9da3-c681f1fc040a" />

<img width="1001" height="499" alt="image" src="https://github.com/user-attachments/assets/9aed8bcc-7ecc-4d6c-ba2c-ac9d61eaabf2" />

<img width="1001" height="534" alt="image" src="https://github.com/user-attachments/assets/7e6461bd-dd09-4e12-916e-2b1f9e2cb046" />

<img width="1001" height="559" alt="image" src="https://github.com/user-attachments/assets/f679e949-fc31-4a1e-8330-08c1962f79f8" />

<img width="1001" height="753" alt="image" src="https://github.com/user-attachments/assets/e0223fdb-6a31-4245-a895-0e7f16f8cb2b" />

<img width="1001" height="216" alt="image" src="https://github.com/user-attachments/assets/50310490-ceca-4024-9ae7-2349f0b99fee" />

<img width="743" height="367" alt="image" src="https://github.com/user-attachments/assets/f7c15d6a-6ee6-4e10-9181-40e7df8335ac" />

## Step 4: Create diskgroup in ASM
[bash_grid]: 

	```
	asmca
	```

<img width="1185" height="316" alt="image" src="https://github.com/user-attachments/assets/6f77930b-cdff-477a-b9a5-4b6b9e115f2c" />

<img width="1185" height="216" alt="image" src="https://github.com/user-attachments/assets/0c5e21c2-6af0-4226-ae02-eb9598a312e4" />

## Step 5: Install Oracle Software
[bash_grid]: 

	```
	export DISPLAY=192.168.58.1:0.0
	cd /u01/app/oracle/product/19c/dbhome_1
	./runInstaller
	```
<img width="999" height="266" alt="image" src="https://github.com/user-attachments/assets/d3efee06-e474-47f5-9517-5c4720c57f1e" />

<img width="999" height="223" alt="image" src="https://github.com/user-attachments/assets/63e230d8-9666-4500-afe9-5c3d6e8a3dfb" />

<img width="999" height="221" alt="image" src="https://github.com/user-attachments/assets/26f00ea1-ebc8-4c91-9e8d-5111d8d325ed" />

<img width="999" height="296" alt="image" src="https://github.com/user-attachments/assets/fc073559-1564-4c16-a135-69d3df50bfaa" />

<img width="999" height="292" alt="image" src="https://github.com/user-attachments/assets/914bcc52-a4a6-4d09-8b12-dbf865a11953" />

<img width="999" height="400" alt="image" src="https://github.com/user-attachments/assets/e071bf4f-7c08-4f8c-96c6-44451dfa8ebd" />

## Step 6: Create database
[bash_oracle]:
```
export DISPLAY=192.168.58.1:0.0
cd $ORACLe_HOME
dbca
```
<img width="1001" height="336" alt="image" src="https://github.com/user-attachments/assets/4de96a06-97ba-4b7b-b71a-b2b8edc27b74" />

<img width="1001" height="516" alt="image" src="https://github.com/user-attachments/assets/7e8e1618-3486-435b-9043-15d2207b7a27" />

<img width="1001" height="448" alt="image" src="https://github.com/user-attachments/assets/ede43f96-7d7d-4f55-8757-9e210065f54e" />

<img width="1001" height="263" alt="image" src="https://github.com/user-attachments/assets/fef905cb-6eac-4df6-ac47-93ae3b4962d7" />

<img width="1001" height="276" alt="image" src="https://github.com/user-attachments/assets/578111ad-6d65-4091-bace-b49570ecbfc3" />

<img width="1001" height="439" alt="image" src="https://github.com/user-attachments/assets/33a66ae0-9b30-4b9d-8da2-a9b2065faa2a" />

<img width="1001" height="343" alt="image" src="https://github.com/user-attachments/assets/164ecf0f-5d8b-42cb-8b8e-fc9595a1d313" />

<img width="1001" height="485" alt="image" src="https://github.com/user-attachments/assets/b0087981-05f1-4dcb-8116-cc7484334650" />







  
