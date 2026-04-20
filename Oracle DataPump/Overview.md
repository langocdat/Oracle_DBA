# Prerequire
1. Đường dẫn chứa file dump

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

3. User dump
4. 
