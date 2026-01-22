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
### 1. Use Udev
1. Create file .rules
- Path: /etc/udev/rules.d/
- Example: [bash_root]: ```vi 99-oracle-asm.rules```
- Contents:
```
KERNEL=="sdb", ENV{ID_SERIAL}=="VBOX_HARDDISK_VBf5b28eeb-d612bbec", \
	SYMLINK+="ASM_DATA", OWNER="grid", GROUP="asmadmin", MODE="0660"
KERNEL=="sdc", ENV{ID_SERIAL}=="VBOX_HARDDISK_VBd15e4846-3269ed1b", \
	SYMLINK+="ASM_FRA", OWNER="grid", GROUP="asmadmin", MODE="0660"
```
2. Query:
[bash_root]: ```lsblk```
[bash_root]: ```fdisk -l```
[bash_root]: ```udevadm info --query=all --name=/dev/sde```
3. Reload
[bash_root]: ```udevadm control --reload-rules && udevadm trigger```
[bash_root]: ```ls -ln /dev/ASM*```



  
