# Step 1: 
```
[oracle@srvdc dbhome_1]$ ./runInstaller -applyRU /u01/software/40121665/39922757
Preparing the home to patch...
Applying the patch /u01/software/40121665/39922757...
Successfully applied the patch.
The log can be found at: /u01/app/oraInventory/logs/InstallActions2026-11-25_08-53-30PM/installerPatchActions_2026-11-25_08-53-30PM.log
Launching Oracle Database Setup Wizard...
```
<img width="1000" height="393" alt="image" src="https://github.com/user-attachments/assets/d3c1de38-f3cd-4661-985e-9f63f98afad8" />

# Step 2:
```
[oracle@srvdc bin]$ java -jar /u01/software/autoupgrade.jar -version
build.version 26.7.2.261111
build.date 2026/11/11 04:27:02 +0000
build.hash 5612244ef
build.hash_date 2026/11/10 20:13:34 +0000
build.supported_target_versions 12.2,18,19,21,23,26
build.type production
build.label (HEAD -> sysbranch_v26.7.2)
build.MOS_NOTE KB123450
build.MOS_LINK https://support.oracle.com/support/?anchorId=&kmContentId=2485457
```

# Step 3:
*scp autoupgrade.jar to /u01/software*

[oracle@srvdc ~]$ mkdir -p /home/oracle/autoupgrade/logs

[oracle@srvdc ~]$ vi config_19c.cfg

```
global.autoupg_log_dir=/home/oracle/autoupgrade/logs
upg1.start_time=NOW
upg1.source_home=/u01/app/oracle/product/12c/dbhome_1
upg1.target_home=/u01/app/oracle/product/19c/dbhome_1
upg1.sid=orcl
upg1.log_dir=/home/oracle/autoupgrade/logs/orcl
upg1.upgrade_node=srvdc.localdomain
upg1.run_utlrp=yes
upg1.timezone_upg=yes
upg1.target_version=19
```

# Step 4:
[oracle@srvdc ~]$ /u01/app/oracle/product/19c/dbhome_1/jdk/bin/java -jar /u01/software/autoupgrade.jar -config /home/oracle/autoupgrade/config_19c.cfg -mode analyze
```
AutoUpgrade 26.7.2.261111 launched with default internal options
Processing config file ...
+--------------------------------+
| Starting AutoUpgrade execution |
+--------------------------------+
1 Non-CDB(s) will be analyzed
Type 'help' to list console commands
upg> Job 102 completed
------------------- Final Summary --------------------
Number of databases            [ 1 ]

Jobs finished                  [1]
Jobs failed                    [0]

Checks Report
+------------+------+-----------+---------+-------+-------+
| Job Number | INFO | RECOMMEND | WARNING | ERROR | Total |
+------------+------+-----------+---------+-------+-------+
| 102        |    7 |         5 |       6 |     0 |    18 |
+------------+------+-----------+---------+-------+-------+

Please read the analyze report below for each job and follow the recommendations.

/home/oracle/autoupgrade/logs/orcl/orcl/102/prechecks/orcl_preupgrade.html
/home/oracle/autoupgrade/logs/orcl/orcl/102/prechecks/orcl_preupgrade.log

Please check the summary report at:
/home/oracle/autoupgrade/logs/cfgtoollogs/upgrade/auto/status/status.html
/home/oracle/autoupgrade/logs/cfgtoollogs/upgrade/auto/status/status.log
```

## Check status and log
```
[oracle@srvdc ~]$ cat /home/oracle/autoupgrade/logs/cfgtoollogs/upgrade/auto/status/status.log
==========================================
          Autoupgrade Summary Report
==========================================
[Date]           Wed Nov 25 22:02:25 ICT 2026
[Number of Jobs] 1
==========================================
[Job ID] 102
==========================================
[DB Name]                orcl
[Version Before Upgrade] 12.2.0.1.0
[Version After Upgrade]  19.33.0.0.0
------------------------------------------
[Stage Name]    PRECHECKS
[Status]        SUCCESS
[Start Time]    2026-11-25 22:01:34
[Duration]      0:00:50
[Log Directory] /home/oracle/autoupgrade/logs/orcl/orcl/102/prechecks
[Detail]        /home/oracle/autoupgrade/logs/orcl/orcl/102/prechecks/orcl_preupgrade.log
                Check passed and no manual intervention needed
```

# Step 5: Fixed mode if have errors
[oracle@srvdc ~]$ /u01/app/oracle/product/19c/dbhome_1/jdk/bin/java -jar /u01/software/autoupgrade.jar -config /home/oracle/autoupgrade/config_19c.cfg -mode fixups

# Step 6: Upgrade

-- Create restore point

SQL> CREATE RESTORE POINT before_upg_1932 GUARANTEE FLASHBACK DATABASE;

-- Xác nhận đã tạo thành công

SQL> SELECT name, guarantee_flashback_database, time FROM v$restore_point;


[oracle@srvdc ~]$ /u01/app/oracle/product/19c/dbhome_1/jdk/bin/java -jar /u01/software/autoupgrade.jar -config /home/oracle/autoupgrade/config_19c.cfg -mode deploy

```
AutoUpgrade 26.7.2.261111 launched with default internal options
Processing config file ...
+--------------------------------+
| Starting AutoUpgrade execution |
+--------------------------------+
1 Non-CDB(s) will be processed
Type 'help' to list console commands
```


