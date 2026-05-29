# Tổng quát:
- Cài đặt Python
- Get mô hình AI dạng Text Embedding
- Đóng gói thành file ONNX
- Import file ONNX vào Database

## 1. Chuẩn bị môi trường
SQL> 
  ```
  ALTER SYSTEM SET vector_memory_size=1G SCOPE=SPFILE;
  startup force;
  ```
  ```
  SELECT CON_ID, POOL, ALLOC_BYTES/1024/1024 as ALLOC_BYTES_MB, USED_BYTES/1024/1024 as USED_BYTES_MB
    FROM V$VECTOR_MEMORY_POOL ORDER BY 1,2;
  ```
Attention: Oracle sẽ tự động cắt 1GB từ tổng dung lượng SGA_TARGET hiện tại để chuyển sang cho vector_memory_size

# Giai đoạn 1: Chuẩn bị môi trường
## 1. Cài đặt python 3.13.5
[bash_oracle]$ ```mkdir -p /home/oracle/python``` -> Đường dẫn python home

[/home/oracle]$ ```wget https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tgz``` -> Tải python

[/home/oracle]$ ```tar -xvzf Python-3.13.5.tgz --strip-components=1 -C /home/oracle/python``` -> Giải nén file cài đặt vào python home

[/home/oracle$ ```/home/oracle/python/configure --enable-shared --prefix=/home/oracle/python``` -> Chỉ định file thực thi, thư viện python

[/home/oracle/python]$ ```make clean``` -> Dọn dẹp các file rác cũ (nếu có)

[/home/oracle/python]$ ```make``` -> Biên dịch mã nguồn thành file chạy

[/home/oracle/python]$ ```make altinstall``` -> Cài đặt

## 2. Configure biến môi trường
  [/home/oracle/python]$ ```vi .bash_profile```
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
## 3. Tạo liên kết symlink
## 4. 
