--==========================================================================================
-- ATTTENSION
  - Cần đọc báo cáo cũ để trả lời các câu hỏi sau:
    * **Danh sách tên những Database cần thực hiện**
    * Hệ thống là RAC hay Guard
      - RAC: **hệ thống có bao nhiêu node, tên node** -> Yêu cầu khách hàng mở máy chủ chứa node đó để thực hiện
      - Guard: Check đồng bộ của standby. (show database <standby_name> hoặc select name, value from v%dataguard_stats)
    * Kiểm tra ngay kết quả file database_information.html
--==========================================================================================
    
