# #APPLY PATCH GRID AND DB WITH OPATCHAUTO
# 1. Chuẩn bị trước khi patch
## 1.1 Tạo folder chứa file patch
[root]:
```
mkdir -p /u01/software
chown oracle:oinstall /u01/software
chmod 775 /u01/software
```

Attention: Tắt Instance trên NODE cần patch

## 1.2 Unzip file patch và OPatch
- Đảm bảo toàn bộ file OPatch trong GRID HOME và ORACLE HOME được thay thế bằng phiên bản mới
- Backup và giải nén OPATCH
[root]:
```
mv OPatch OPatch.bkp
```
## 1.3 Backup GRID_HOME và oraInventory
[root]:
```
cd /u01/app/19.0.0.0
tar -pcvf grid_backup.tar grid
```

[root]:
```
cd /u01/app
tar -pcvf oraInventory.tar oraInventory
```

