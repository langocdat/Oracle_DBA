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

<img width="370" height="124" alt="image" src="https://github.com/user-attachments/assets/5f8bbe86-02ae-4306-8565-bb6d65231649" />


