# I. The DC site
## 1. Configure broker

```
ASMCMD [+DATA/ORCL] > mkdir DGBROKER
ASMCMD [+DATA/ORCL/DGBROKER] > pwd
+DATA/ORCL/DGBROKER
```
```
SQL> alter system set dg_broker_config_file1='+DATA/ORCL/DGBROKER/dr1orcl.dat' scope=both sid='*';
System SET altered.

SQL> alter system set dg_broker_config_file2='+DATA/ORCL/DGBROKER/dr2orcl.dat' scope=both sid='*';
System SET altered.

SQL> alter system set dg_broker_start=true scope=both sid='*';
System SET altered.
```
<img width="878" height="196" alt="image" src="https://github.com/user-attachments/assets/de76cbdc-d9be-40c5-aa14-3de9f0d4e856" />

## 2. Configure Standby Redo Log

 - *Attention: Standby Redo Log = Online Redo log + 1*

```
SQL> alter system set db_create_online_log_dest_1='+DATA' scope=both sid='*';
System SET altered.

SQL> alter system set db_create_online_log_dest_2='+FRA' scope=both sid='*';
System SET altered.
```

<img width="428" height="130" alt="image" src="https://github.com/user-attachments/assets/b5c9c062-7fa7-4be5-bee4-dc8f1a51dfc3" />

- *Online Redo log number*
```
set lines 200 pages 200
col member for a85
select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;
```

<img width="1593" height="309" alt="image" src="https://github.com/user-attachments/assets/e0830581-218a-4846-b9d8-08cb1c6c6290" />

- *Standby Redo log number*
```
set lines 200 pages 200
col member for a85
select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$standby_log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;
```
```
SQL> alter database add standby logfile thread 1 group 11 size 200M;
Database altered.

SQL> alter database add standby logfile thread 1 group 12 ('+DATA', '+FRA') SIZE 200M;
Database altered.
```
