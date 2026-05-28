# 1. Overview
- OS: Linux 8.10
  ```https://download.oracle.com/otn/linux/oracle26ai/2326100/oracle-ai-database-ee-26ai-1.0-1.el8.x86_64.rpm```
- GRID: LINUX.X64_2326100_grid_home.zip
  ```https://download.oracle.com/otn/linux/oracle26ai/2326100/LINUX.X64_2326100_grid_home.zip```
- Database: LINUX.X64_2326100_db_home.zip
  ```https://download.oracle.com/otn/linux/oracle26ai/2326100/LINUX.X64_2326100_db_home.zip```

Link download: https://www.oracle.com/database/technologies/oracle26ai-linux-downloads.html 

# 2. Install LINUX 8.10
### 2.1 Configure hostname
[root]$ ```hostnamectl set-hostname srv26AI.localdomain```

### 2.2 Configure IP
[root]$ ```nmcli con show```

[root]$ ```vi /etc/sysconfig/network-scripts/ifcfg-...```

| STT | NAME | IP | 
| :-- | :-- | :-- |
| 1 | Host Only | 192.168.58.60

## 2.3 Install Package
[root]$ 
  ```
  yum update -y  
  yum list | grep 19c -i
  yum install oracle-database-preinstall-19c.x86_64 -y
  yum list | grep oracleasm -i
  yum install oracleasm-support.x86_64 -y
  ```


# 3. Install GRID
# 4. Install Database
# 5. Install AI to Database
Tổng quát:
- Cài đặt Python
- Get mô hình AI dạng Text Embedding
- Đóng gói thành file ONNX
- Import file ONNX vào Database
