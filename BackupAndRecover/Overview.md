1. Khái niệm cơ bản
   - Exprired: các file backup, archivelog chỉ tồn tại trên RMAN và đã bị xóa trên OS (tức xóa tay).
   - Obsolete: các file backup, archivelog tồn tại trên cả RMAN và OS. Nhưng chúng được RMAN xác định không còn phù hợp theo Policy -> lỗi thời.
   - Lệnh tạo archivelog để test:
     + (sqlplus): alter system switch logfile;
3. Retention policy
   - Check policy
     + (RMAN): show all;
     + (RMAN): show retention policy;
       
       <img width="520" height="360" alt="image" src="https://github.com/user-attachments/assets/f46577b2-3ba6-490c-ab79-4512681689bf" />
       
   - Recovery Window: giữ backup, archivelog đủ để Point in time trong vòng n ngày (có thể configure số ngày lâu hơn).
     + (RMAN): Configure Retention policy to recovery window 7 days;
       -> giữ backup, archivelog trong vòng 7 ngày.
   - Redundancy: giữ số lượng backup full (level 0) mới nhất.
     + (RMAN): Configure Retention policy to redundancy 2;
       -> giữ 2 backup full mới nhất.
       
       <img width="247" height="173" alt="image" src="https://github.com/user-attachments/assets/78f7eef3-dfd9-44ee-a8b1-530c8b76533f" />
       
       -> Mỗi backup level 0 sẽ đi kèm các backup level 1. Do vậy, khi backup level 0 của CN bị RMAN đánh dấu là obsolete nên backup level 1 của CN cũng bị RMAN đánh dấu là obsolete.
4. Kiểm tra và xóa backup, archivelog obsolete
   - Check backup và archivelog obsolete theo policy:
     + (RMAN): report obsolete;
   - Delete backup và archivelog obsolete theo policy:
     + (RMAN): delete noprompt obsolete;
   - Check backup expired:
     + (RMAN): crosscheck backup;
     + (RMAN): list backup summary;
   - Delete backup expired:
     + (RMAN): delete noprompt expired backup;
   - Check archivelog expired:
     + (RMAN): crosscheck archivelog all;
     + (RMAN): list expired archivelog all; 
   - Delete archivelog expired:
     + (RMAN): delete noprompt expired archivelog all;
   - Delete archivelog cưỡng ép dựa trên thời gian (không khuyến nghị):
     + (RMAN): delete archivelog until time 'sysdate - 15';
       -> Xóa archivelog cũ hơn 15 ngày, tức giữ archivelog của 15 ngày mới nhất.
5. Liên hệ với scripts backup
   - Đối với backup level 0:
     
     <img width="645" height="718" alt="image" src="https://github.com/user-attachments/assets/43a686f8-2cb3-4239-9b2e-92b2fb92bb8f" />

6. How to check validate từng file backup, tức kiểm tra file backup có dùng được hay ko
   - Step 1: Lấy BackupSet key theo tag
     + (RMAN): LIST BACKUP TAG 'WEEKLY_FULL_20260112';
       
      BS Key  Type LV Size    Completion Time
      ------- ---- -- ------- ----------------
      123     Full  0  35.2G  12-JAN-26
     
   - Step 2: Validate bằng BackupSet Key
     + (RMAN): VALIDATE BACKUPSET 123;
