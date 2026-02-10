## Có 3 view quan trọng cần biết:
  - v$log: chứa thông tin của Online redo log -> được sử dụng khi DB có vai trò primay
  - v$standby_log: chứa thông tin của standby redo log -> được sử dụng khi DB có vai trò standby
  - v$logfile: chứa thông tin chung cho cả v$log và v$standby_log
# HOW TO SHOW INFROMATION
## 1. ONLINE REDO LOG

SQL> ```SELECT l.GROUP#, l.STATUS, lf.MEMBER, lf.TYPE FROM V$LOG l JOIN V$LOGFILE lf ON l.GROUP# = lf.GROUP#  order by l.GROUP#;```

```
    GROUP# STATUS           MEMBER                                                                 TYPE
---------- ---------------- ---------------------------------------------------------------------- -------
         1 CURRENT          +FRA/ORCL/ONLINELOG/group_1.258.1223979401                             ONLINE
         1 CURRENT          +DATA/ORCL/ONLINELOG/group_1.262.1223979401                            ONLINE
         2 INACTIVE         +FRA/ORCL/ONLINELOG/group_2.257.1223979401                             ONLINE
         2 INACTIVE         +DATA/ORCL/ONLINELOG/group_2.263.1223979401                            ONLINE
         3 INACTIVE         +DATA/ORCL/ONLINELOG/group_3.266.1223979767                            ONLINE
         3 INACTIVE         +FRA/ORCL/ONLINELOG/group_3.259.1223979769                             ONLINE
         4 CURRENT          +DATA/ORCL/ONLINELOG/group_4.267.1223979769                            ONLINE
         4 CURRENT          +FRA/ORCL/ONLINELOG/group_4.260.1223979769                             ONLINE
```
## 2. STANDBY REDO LOG

SQL> ```SELECT l.GROUP#, l.STATUS, lf.MEMBER, lf.TYPE FROM V$STANDBY_LOG l JOIN V$LOGFILE lf ON l.GROUP# = lf.GROUP# order by l.GROUP#;```

```
    GROUP# STATUS     MEMBER                                                                 TYPE
---------- ---------- ---------------------------------------------------------------------- -------
         5 UNASSIGNED +FRA/ORCL/ONLINELOG/group_5.274.1224845743                             STANDBY
         6 UNASSIGNED +FRA/ORCL/ONLINELOG/group_6.275.1224845805                             STANDBY
         7 UNASSIGNED +FRA/ORCL/ONLINELOG/group_7.276.1224845809                             STANDBY
         9 UNASSIGNED +FRA/ORCL/ONLINELOG/group_9.278.1224845851                             STANDBY
        10 UNASSIGNED +FRA/ORCL/ONLINELOG/group_10.279.1224845853                            STANDBY
        11 UNASSIGNED +FRA/ORCL/ONLINELOG/group_11.280.1224845855                            STANDBY
```
# HOW TO ADD GROUP
## 1. ONLINE REDO LOG
## 2. STANDBY REDO LOG

SQL> 
```
ALTER DATABASE ADD STANDBY LOGFILE THREAD 1 '+DATA' SIZE 50M;
ALTER DATABASE ADD STANDBY LOGFILE THREAD 2 '+FRA' SIZE 50M;
```
