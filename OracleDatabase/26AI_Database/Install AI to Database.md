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

[root]$ ```wget https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tgz``` -> Tải python

[/home/oracle]$ ```tar -xvzf Python-3.13.5.tgz --strip-components=1 -C /home/oracle/python``` -> Giải nén file cài đặt vào python home

[/home/oracle]$ ```/home/oracle/python/configure --enable-shared --prefix=/home/oracle/python``` -> Chỉ định file thực thi, thư viện python

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
  [/home/oracle]$ 
  ```
  cd /home/oracle/python/bin
  ln -sf python3.13 python3
  ln -sf pip3.13 pip3
  ```

  Kiểm tra kết quẳ
  
  [/home/oracle]$ which python3
  
  ```/home/oracle/python/bin/python3```
  
  [/home/oracle]$ python3 --version
  
  ```Python 3.13.5```
  
## 4. Tạo file requirements.txt chứa thư viện python
[/home/oracle]$
```
cat << 'EOF' > /home/oracle/requirements.txt
--extra-index-url https://download.pytorch.org/whl/cpu
pandas==2.2.3
setuptools==80.8.0
scipy==1.14.1
matplotlib==3.10.0
oracledb==3.3.0
scikit-learn==1.6.1
numpy==2.1.0
pyarrow==19.0.0
onnxruntime==1.20.0
onnxruntime-extensions==0.14.0
onnx==1.18.0
torch==2.9.0
transformers==4.56.1
sentencepiece==0.2.1
EOF
```
- Nâng cấp gói
  [/home/oracle]$ ```pip3 install --upgrade pip```

  <img width="773" height="243" alt="image" src="https://github.com/user-attachments/assets/952bdbd2-ca0e-44dd-bbfa-1720e298438d" />

- Cài đặt thư viện
  [/home/oracle]$ ```pip3 install -r /home/oracle/requirements.txt```

  <img width="1157" height="326" alt="image" src="https://github.com/user-attachments/assets/c414c193-043d-4d04-87e2-405ae4e29555" />

- Trường hợp cài thiếu thư viện:
  
  [root]: ```yum install -y libffi-devel```

  Biên dịch lại

  [oracle]$
  ```
  cd /home/oracle/python
  ./configure --enable-shared --prefix=/home/oracle/python
  make clean
  make
  make altinstall
  ```

## 5. Cài đặt OML4Py Client của Oracle
- Link download: https://www.oracle.com/database/technologies/oml4py-downloads.html

  <img width="1192" height="367" alt="image" src="https://github.com/user-attachments/assets/69faa2f7-8fe6-46a9-9d85-b57af8ab66a2" />

  <img width="737" height="147" alt="image" src="https://github.com/user-attachments/assets/8014a087-d57f-4d2f-b84e-e8c5c459404e" />

  [/home/oracle]$
  ```
  cd /home/oracle
  unzip oml4py-client-linux-x86_64-2.1.1.zip
  pip3 install client/oml-2.1.1-cp313-cp313-linux_x86_64.whl
  ```

  <img width="580" height="139" alt="image" src="https://github.com/user-attachments/assets/1c126d9b-7e05-42d1-85c5-fb208225c243" />

  <img width="1416" height="524" alt="image" src="https://github.com/user-attachments/assets/a38e685d-33b4-49af-a76e-b4c1f2ba7e4b" />

## 6. 
