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
