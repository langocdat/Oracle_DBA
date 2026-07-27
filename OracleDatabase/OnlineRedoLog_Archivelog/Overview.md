## Có 3 view quan trọng cần biết:
  - v$log: chứa thông tin của Online redo log -> được sử dụng khi DB có vai trò primay
  - v$standby_log: chứa thông tin của standby redo log -> được sử dụng khi DB có vai trò standby
  - v$logfile: chứa thông tin chung cho cả v$log và v$standby_log
# HOW TO SHOW INFROMATION
## 1. ONLINE REDO LOG

SQL> ```select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;```

```
   GROUP#    THREAD#    MB_SIZE      TYPE                                         MEMBER      STATUS
_________ __________ __________ _________ ______________________________________________ ___________
        1          1        500 ONLINE    +DATA/ORCL/ONLINELOG/group_1.263.1239720385    CURRENT
        1          1        500 ONLINE    +FRA/ORCL/ONLINELOG/group_1.259.1239720387     CURRENT
        3          1        500 ONLINE    +DATA/ORCL/ONLINELOG/group_3.264.1239720441    INACTIVE
        3          1        500 ONLINE    +FRA/ORCL/ONLINELOG/group_3.318.1239720443     INACTIVE
        4          1        500 ONLINE    +DATA/ORCL/ONLINELOG/group_4.274.1239720567    INACTIVE
        4          1        500 ONLINE    +FRA/ORCL/ONLINELOG/group_4.306.1239720569     INACTIVE
        5          1        500 ONLINE    +FRA/ORCL/ONLINELOG/group_5.309.1239720491     INACTIVE
        5          1        500 ONLINE    +DATA/ORCL/ONLINELOG/group_5.275.1239720489    INACTIVE
        6          1        800 ONLINE    +FRA/ORCL/ONLINELOG/group_6.317.1239723929     INACTIVE
        6          1        800 ONLINE    +DATA/ORCL/ONLINELOG/group_6.262.1239723927    INACTIVE
```
## 2. STANDBY REDO LOG

SQL> ```select l.group#, l.thread#, l.bytes/1024/1024 as MB_size, f.type, f.member, l.status from v$standby_log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;```

```
   GROUP#    THREAD#    MB_SIZE       TYPE                                          MEMBER        STATUS
_________ __________ __________ __________ _______________________________________________ _____________
       11          1        200 STANDBY    +DATA/ORCL/ONLINELOG/group_11.272.1236112591    UNASSIGNED
       11          1        200 STANDBY    +FRA/ORCL/ONLINELOG/group_11.263.1236112591     UNASSIGNED
       12          1        200 STANDBY    +DATA/ORCL/ONLINELOG/group_12.271.1236112593    UNASSIGNED
       12          1        200 STANDBY    +FRA/ORCL/ONLINELOG/group_12.262.1236112593     UNASSIGNED
       13          1        200 STANDBY    +DATA/ORCL/ONLINELOG/group_13.270.1236112593    UNASSIGNED
       13          1        200 STANDBY    +FRA/ORCL/ONLINELOG/group_13.261.1236112595     UNASSIGNED
       14          1        200 STANDBY    +DATA/ORCL/ONLINELOG/group_14.273.1236112595    UNASSIGNED
       14          1        200 STANDBY    +FRA/ORCL/ONLINELOG/group_14.264.1236112595     UNASSIGNED

```
# HOW TO CHECK
```
set lines 200 pages 200
col member for a85
select l.group#, l.thread#, l.bytes, f.type, f.member, l.status from v$log l, v$logfile f where l.group#=f.group# order by f.type, l.group#; 
select l.group#, l.thread#, l.bytes, f.type, f.member, l.status from v$standby_log l, v$logfile f where l.group#=f.group# order by f.type, l.group#;
```
# HOW TO ADD GROUP
## 1. ONLINE REDO LOG

SQL>
```
ALTER DATABASE ADD LOGFILE MEMBER '+FRA' TO GROUP 1;
ALTER DATABASE ADD LOGFILE MEMBER '+FRA' TO GROUP 2;
```

## 2. STANDBY REDO LOG

SQL> 
```
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 '+DATA' SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 '+FRA' SIZE 50M;
```
