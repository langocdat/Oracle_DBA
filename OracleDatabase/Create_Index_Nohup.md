# Check table, column cần tạo index
	```
	SET LINESIZE 300
	SET PAGESIZE 1000
	SET TRIMSPOOL ON
	
	COLUMN owner                  FORMAT A15
	COLUMN table_name             FORMAT A35
	COLUMN constraint_name        FORMAT A35
	COLUMN parent_owner           FORMAT A15
	COLUMN parent_table_name      FORMAT A35
	COLUMN parent_constraint_name FORMAT A35
	COLUMN col_01                 FORMAT A20
	COLUMN col_02                 FORMAT A20
	COLUMN col_03                 FORMAT A20
	COLUMN col_04                 FORMAT A20
	
	WITH
	ref_int_constraints AS (
	SELECT
	col.owner,
	col.table_name,
	col.constraint_name,
	con.status,
	con.r_owner,
	con.r_constraint_name,
	COUNT(*) col_cnt,
	MAX(CASE col.position WHEN 01 THEN col.column_name END) col_01,
	MAX(CASE col.position WHEN 02 THEN col.column_name END) col_02,
	MAX(CASE col.position WHEN 03 THEN col.column_name END) col_03,
	MAX(CASE col.position WHEN 04 THEN col.column_name END) col_04,
	MAX(CASE col.position WHEN 05 THEN col.column_name END) col_05,
	MAX(CASE col.position WHEN 06 THEN col.column_name END) col_06,
	MAX(CASE col.position WHEN 07 THEN col.column_name END) col_07,
	MAX(CASE col.position WHEN 08 THEN col.column_name END) col_08,
	MAX(CASE col.position WHEN 09 THEN col.column_name END) col_09,
	MAX(CASE col.position WHEN 10 THEN col.column_name END) col_10,
	MAX(CASE col.position WHEN 11 THEN col.column_name END) col_11,
	MAX(CASE col.position WHEN 12 THEN col.column_name END) col_12,
	MAX(CASE col.position WHEN 13 THEN col.column_name END) col_13,
	MAX(CASE col.position WHEN 14 THEN col.column_name END) col_14,
	MAX(CASE col.position WHEN 15 THEN col.column_name END) col_15,
	MAX(CASE col.position WHEN 16 THEN col.column_name END) col_16,
	par.owner parent_owner,
	par.table_name parent_table_name,
	par.constraint_name parent_constraint_name
	FROM dba_constraints con,
	     dba_cons_columns col,
	     dba_constraints par
	WHERE con.constraint_type = 'R'
	AND con.owner = 'VIMES'
	AND col.owner = con.owner
	AND col.constraint_name = con.constraint_name
	AND col.table_name = con.table_name
	AND par.owner(+) = con.r_owner
	AND par.constraint_name(+) = con.r_constraint_name
	GROUP BY
	col.owner,
	col.constraint_name,
	col.table_name,
	con.status,
	con.r_owner,
	con.r_constraint_name,
	par.owner,
	par.constraint_name,
	par.table_name
	),
	ref_int_indexes AS (
	SELECT /*+ MATERIALIZE NO_MERGE */
	r.owner,
	r.constraint_name,
	c.table_owner,
	c.table_name,
	c.index_owner,
	c.index_name,
	r.col_cnt
	FROM ref_int_constraints r,
	     dba_ind_columns c,
	     dba_indexes i
	WHERE c.table_owner = r.owner
	AND c.table_name = r.table_name
	AND c.column_position <= r.col_cnt
	AND c.column_name IN (
	    r.col_01, r.col_02, r.col_03, r.col_04,
	    r.col_05, r.col_06, r.col_07, r.col_08,
	    r.col_09, r.col_10, r.col_11, r.col_12,
	    r.col_13, r.col_14, r.col_15, r.col_16
	)
	AND i.owner = c.index_owner
	AND i.index_name = c.index_name
	AND i.table_owner = c.table_owner
	AND i.table_name = c.table_name
	AND i.index_type != 'BITMAP'
	GROUP BY
	r.owner,
	r.constraint_name,
	c.table_owner,
	c.table_name,
	c.index_owner,
	c.index_name,
	r.col_cnt
	HAVING COUNT(*) = r.col_cnt
	)
	SELECT
	owner,
	table_name,
	constraint_name,
	parent_table_name,
	col_01,
	col_02,
	status
	FROM ref_int_constraints c
	WHERE NOT EXISTS (
	    SELECT NULL
	    FROM ref_int_indexes i
	    WHERE i.owner = c.owner
	    AND i.constraint_name = c.constraint_name
	)
	ORDER BY owner, table_name;
	```

Expect Result 
	```
	CREATE INDEX VIMES.HMS_EXAM_HMS_ROOMLIST_FK1_IDX ON VIMES.HMS_EXAM(HE_DEPTID,HE_ROOMID) TABLESPACE DBVIMES ;
	```
# Create index nohup 

Step 1: Prepare scripts run nohup

(bash_oracle): vi create_index.sh
	```
	export ORACLE_SID=orcl1
	export ORACLE_HOME=/u01/app/oracle/product/19c/dbhome_1
	export PATH=$ORACLE_HOME/bin:$PATH
	sqlplus / as sysdba << EOF
	spool /home/oracle/create_index_output.txt
	SET TIMING ON;
	DROP INDEX idx_employee_id;
	create index idx_employee_id on EMPLOYEE(ID);
	exit;
	EOF
	```
Step 2: permission

	(bash): chmod +x create_index.sh 
	
Step 3: run scipts in backgroud	

	(bash): nohup ./create_index.sh > /home/oracle/create_index.log 2>&1 &
	
# Check index

SQL>

	col index_name format A30;
	col status format A20;
	select index_name, status from user_indexes where index_name = 'IDX_EMPLOYEE_ID';
