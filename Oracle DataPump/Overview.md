# Prerequire
## 1. Đường dẫn chứa file dump
### Check các directory đang tồn tại
OS> ```mkdir -p exp_dump```

SQL> `sqlplus / as sysdba -> Tạo directory object`

scripts name: ls.sql

```
set linesize 150;
set pagesize 200;
set verify off
col owner format a10;
col directory_name format a25;
col directory_path format a75;
define vname='&1'
select owner, directory_name, directory_path from dba_directories where directory_name like upper('%&vname%') order by 2
/
```
```
set linesize 150;
set pagesize 200;
col owner format a10;
col directory_name format a25;
col directory_path format a75;
select owner, directory_name, directory_path from dba_directories where directory_name order by 2;
```
### Tạo directory mới
SQL>
```
create directory <directory_name> as '<đường dẫn ngoài OS>';
create directory exp_demo as '/home/oracle/exp_demo';
```
## 2. User dump

- Có thể sử dụng quyền user sysdba

## 3. Thực hiện export
```
Một câu lệnh expdp thường gồm:

- Kết nối database
- Directory (bắt buộc)
- Dumpfile + Logfile
- Phạm vi export (FULL / SCHEMA / TABLE / TABLESPACE)
- Tùy chọn bổ sung (lọc, nén, parallel, version…)
```

OS> 
```
expdp \" / as sysdba \" directory=<directory_name>
```
4. 
5. 
