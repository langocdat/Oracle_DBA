1. Tạo ASM disk.
2. Kiểm tra ASM disks.
3. Add disk vào ASM diskgroup.
4. Kiểm tra trạng thái rebalance.
5. Kiểm tra đĩa mới trong ASM Diskgroup

=====================================================

Step 1: Add disk thô vào máy chủ

<img width="580" height="223" alt="image" src="https://github.com/user-attachments/assets/b82124b1-4f34-4660-869e-82e7cbc5945d" />

===>>> Start máy chủ OS

Step 2: List disk OS đã nhận
 - (bash_root): fdisk -l
   
<img width="978" height="337" alt="image" src="https://github.com/user-attachments/assets/80325901-afdc-4d1e-8079-810c0f04cb4f" />


Step 3: Định dạng disk thô
 - (bash_root): fdisk /dev/sdf
   
<img width="757" height="554" alt="image" src="https://github.com/user-attachments/assets/9387f080-83a0-458e-ba5f-19d11ae975fb" />

- Check: (bash_root): fdisk -l
  
<img width="662" height="199" alt="image" src="https://github.com/user-attachments/assets/71633139-4ff6-42bf-a68e-512b21a40cf0" />

Step 4: Partition disk
- Before
(bash_root): oracleasm scandisks
(bash_root): oracleasm listdisks

<img width="390" height="107" alt="image" src="https://github.com/user-attachments/assets/b275ed6e-b05f-4903-b019-118b65071d72" />

- Perform:
(bash_root): oracleasm createdisk DATA_0003 /dev/sdf1

<img width="580" height="69" alt="image" src="https://github.com/user-attachments/assets/72706048-5736-4f51-82fc-9f5ed71b50dd" />

- After
(bash_root): oracleasm scandisks
(bash_root): oracleasm listdisks

<img width="439" height="123" alt="image" src="https://github.com/user-attachments/assets/bba137e4-7680-4795-951c-ffd23a88e86a" />

Step 5: add disk và diskgroup 
(ở đây add vào diskgroup DATA)
- Before: (bash_grid): asmcmd lsdg

<img width="1528" height="133" alt="image" src="https://github.com/user-attachments/assets/f3dde8a4-bf5c-4a09-b62c-dcc5e0c49f81" />

- Perform:
  + (bash_grid): sqlplus / as sysasm
   
    <img width="731" height="266" alt="image" src="https://github.com/user-attachments/assets/376ab208-a6c7-4a38-be18-1d0dad8b4218" />

  + (sqlplus_asm): alter diskgroup DATA add disk '/dev/oracleasm/disks/DATA_0003' name DATA_0003 rebalance power 16;

    <img width="1069" height="88" alt="image" src="https://github.com/user-attachments/assets/1ea6c573-725d-43c9-bc4c-6a8bf60faa36" />

- Check:
  + (sqlplus_asm):
    * set lines 9999;
    * col diskgroup for a15
    * col diskgroup for a15
    * col path for a35
  
     select a.name DiskGroup,b.name DiskName, b.total_mb, (b.total_mb-b.free_mb) Used_MB, b.free_mb,b.path,b.header_status from v$asm_disk b, v$asm_diskgroup a where a.group_number (+) =b.group_number order by b.group_number,b.name;

    <img width="1219" height="176" alt="image" src="https://github.com/user-attachments/assets/16ba240c-2cbb-4f7f-974f-fa0b43bb593d" />

  + (bash_grid): asmcmd lsdg

    <img width="1532" height="118" alt="image" src="https://github.com/user-attachments/assets/5f8ae4b8-fdd5-4e31-905c-9ec3abeb8759" />



