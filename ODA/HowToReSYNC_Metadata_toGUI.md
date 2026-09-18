[root@vn-evi-srv-db01 ~]# ```odacli update-registry -n DB -u vnevisa```
```
Job details
----------------------------------------------------------------
                     ID:  3e3b4ae1-4ee5-4eff-b181-6452dce4411d
            Description:  Discover Components : db
                 Status:  Created
                Created:  September 14, 2026 14:54:36 ICT
                Message:

Task Name                                Node Name                 Start Time                               End Time                                 Status
---------------------------------------- ------------------------- ---------------------------------------- ---------------------------------------- ----------------
```

[root@vn-evi-srv-db01 ~]# ```odacli describe-job -i 3e3b4ae1-4ee5-4eff-b181-6452dce4411d```
```
Job details
----------------------------------------------------------------
                     ID:  3e3b4ae1-4ee5-4eff-b181-6452dce4411d
            Description:  Discover Components : db
                 Status:  Success
                Created:  September 14, 2026 14:54:36 ICT
                Message:

Task Name                                Node Name                 Start Time                               End Time                                 Status
---------------------------------------- ------------------------- ---------------------------------------- ---------------------------------------- ----------------
Discover DBHome                          vn-evi-srv-db01           September 14, 2026 14:54:42 ICT          September 14, 2026 14:54:46 ICT          Success
Discover DBHome                          vn-evi-srv-db01           September 14, 2026 14:54:46 ICT          September 14, 2026 14:54:49 ICT          Success
Discover DB: vnevisa                     vn-evi-srv-db01           September 14, 2026 14:54:49 ICT          September 14, 2026 14:54:58 ICT          Success
```

[root@vn-evi-srv-db01 ~]# ```odacli describe-database -i 43bb630f-38fa-40c7-90a6-d090a38cca51```
```
Database details
----------------------------------------------------------------
                     ID: 43bb630f-38fa-40c7-90a6-d090a38cca51
            Description: vnevisa
                DB Name: vnevisa
             DB Version: 19.32.0.0.260721
                DB Type: RAC
                DB Role: PRIMARY
    DB Target Node Name:
             DB Edition: EE
                  DB ID: 3313925123
 Instance Only Database: false
                    CDB: true
               PDB Name:
     PDB Admin Username:
      High Availability: false
                  Class: OLTP
                  Shape: odb1
                Storage: ASM
          DB Redundancy:
          Character Set: AL32UTF8
 National Character Set: AL16UTF16
               Language: AMERICAN
              Territory: AMERICA
                Home ID: c9db4c29-d660-4846-997d-27420cedeb30
        Console Enabled: false
  TDE Wallet Management:
            TDE Enabled: false
     Level 0 Backup Day: sunday
    Auto Backup Enabled: false
                Created: September 14, 2026 2:54:49 PM ICT
         DB Domain Name:
    Associated Networks:
          CPU Pool Name:


Pluggable Databases
--------------------------------------------------
                 PDB ID: 9bad7ecd-ecce-4f7b-9049-5ea196c8bd35
               PDB Name:
             PDB Source:
```

[root@vn-evi-srv-db01 ~]# ```odacli list-databases```
```
ID                                       DB Name    DB Type  DB Version           CDB     Class    Edition  Shape    Storage  Status       DB Home ID                  
---------------------------------------- ---------- -------- -------------------- ------- -------- -------- -------- -------- ------------ ----------------------------------------
43bb630f-38fa-40c7-90a6-d090a38cca51     vnevisa    RAC      19.32.0.0.260721     true    OLTP     EE       odb1     ASM      CONFIGURED   c9db4c29-d660-4846-997d-27420cedeb30
de2382b8-0395-4e5a-9ad8-b58c2cb4bb68     vnkbtt     RAC      19.0.0.0             true    OLTP     EE       odb1     ASM      FAILED       c9db4c29-d660-4846-997d-27420cedeb30
```
