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
