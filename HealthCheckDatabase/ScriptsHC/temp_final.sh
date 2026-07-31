#!/bin/ksh

# Configuration folder
ENV_DIR="/home/oracle/bin"

# Configuration env scripts
diag="V\$DIAG_INFO"
database="V\$DATABASE"
parameter="V\$PARAMETER"
datafile="V\$DATAFILE_HEADER"
instance="V\$INSTANCE"
backupjob="V\$RMAN_BACKUP_JOB_DETAILS"
host=$(hostname)
os=$(uname)

# Check folder containing env file
if [[ ! -d "$ENV_DIR" ]]; then
    mkdir -p $ENV_DIR
fi

env_files=($(ls "$ENV_DIR" 2>/dev/null))

# Get number env file
total_files=${#env_files[@]}

if [[ $total_files -eq 0 ]]; then
	echo ""
	echo "==>> WARNING: Please create ENV file in $ENV_DIR."
	exit 1
fi

# =========================================================
# STEP 1: CHỌN CÁC CSDL (TƯƠNG THÍCH LINUX, REDHAT, AIX, SOLARIS)
# =========================================================
show_menu_env() {
    echo "=========================================================================="
    echo "                      LIST OF ORACLE ENVIRONMENT                          "
    echo "=========================================================================="
    i=1
    for f in "${env_files[@]}"; do
        # Sao lưu biến môi trường cũ
        OLD_SID=$ORACLE_SID
        OLD_HOME=$ORACLE_HOME
        OLD_PATH=$PATH
        OLD_LD=$LD_LIBRARY_PATH
        OLD_LIB=$LIBPATH

        # Nạp file môi trường
        . "$ENV_DIR/$f" >/dev/null 2>&1
        
        # Cấu hình PATH & Shared Library chuẩn cho từng OS
        export PATH=$ORACLE_HOME/bin:$PATH
        if [[ "$os" == "AIX" ]]; then
            export LIBPATH=$ORACLE_HOME/lib:$LIBPATH
        else
            export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
        fi

        # Kiểm tra trạng thái CDB
        cdb_type="DOWN/N_A"
        
        # Thử truy vấn CDB trực tiếp qua SQLPlus
        check_cdb=$(sqlplus -s / as sysdba <<EOF
set head off feed off pages 0 lines 200
select cdb from v\$database;
exit
EOF
        )
        
        # Làm sạch chuỗi kết quả
        cdb_val=$(echo "$check_cdb" | tr -d '[:space:]')

        if [[ "$cdb_val" == "YES" ]]; then
            cdb_type="CDB"
        elif [[ "$cdb_val" == "NO" ]]; then
            cdb_type="Non-CDB"
        fi

        # Khôi phục lại biến môi trường ban đầu
        export ORACLE_SID=$OLD_SID
        export ORACLE_HOME=$OLD_HOME
        export PATH=$OLD_PATH
        export LD_LIBRARY_PATH=$OLD_LD
        export LIBPATH=$OLD_LIB

        # In Menu căn lề chuẩn ANSI cho KSH (Chạy tốt trên AIX/Solaris/Linux)
        printf " %-1d) %-35s ||  %-10s\n" $i "$f" "$cdb_type"
        ((i=i+1))
    done
    
    echo " A) Select All (Run All Instance)"
    echo " C) Cancel"
    echo "=========================================================================="
    
    if [[ "$SHELL" == *"ksh"* ]] || [ -n "$KSH_VERSION" ]; then
        read user_choice?"Please fill your choice (Ex: 1, 1 3 4, A, C): "
    else
		echo ""
        read -p "==>> Please fill your choice (Ex: 1, 1 3 4, A, C): " user_choice
    fi
}

show_menu_env

user_choice=$(echo "$user_choice" | tr '[:lower:]' '[:upper:]' | tr ',' ' ')

if [[ "$user_choice" == "C" ]]; then
	echo ""
    echo "==>> Canceled."
	echo ""
    exit 0
fi

selected_files=""

if [[ "$user_choice" == "A" ]]; then
    selected_files="${env_files[@]}"
else
    for choice in $user_choice; do
        if [[ "$choice" -eq "$choice" ]] 2>/dev/null; then
            if (( choice >= 1 && choice <= ${#env_files[*]} )); then
                idx=$((choice - 1))
                selected_files="$selected_files ${env_files[$idx]}"
            else
				echo ""
                echo "==>> WARNING: Option '$choice' invalid. IGNORED."
            fi
        else
			echo ""
            echo "==>> WARNING: Option '$choice' invalid. IGNORED."
        fi
    done
fi

if [[ -z "$selected_files" ]]; then
	echo ""
    echo "==>> No choice. Canceled."
	echo ""
    exit 1
fi

# =========================================================
# STEP 2: CHỌN TÙY CHỌN HEALTH CHECK / OSWATCHER (MENU 1, 2, 3)
# =========================================================
show_menu_option() {
	echo
	echo "|<<=======================<<  ***  >>=======================>>|"
	echo "|                                                             |"
	echo "|                    ---------------------                    |"
	echo "|   <<===>>       << HEALTH-CHECK-DATABASE >>       <<===>>   |"
	echo "|                    ---------------------                    |"
	echo "|                                                             |"
	echo "| ==>> 1. Get Database Information:                           |"
	echo "|         # Disk, Alert_log, Rman, Opatch, Grid               |"
	echo "|         # Backup, Dbinfo, HealthCheck, Awrrpt               |"
	echo "|                                                             |"
	echo "| ==>> 2. Run OSWatcher.                                      |"
	echo "|                                                             |"
	echo "| ==>> 3. Cancel Script.                                      |"
	echo "|                                                             |"
	echo "|                                         Ver_1.3.0_VictorMPS |"
	echo "|<<========================<< *** >>========================>>|"
	echo
	if [[ "$os" == 'Linux' ]]; then
		read -p "Option: " global_option
	else
		read global_option?"Option: "
	fi
}

show_menu_option

if [[ -z $global_option || $global_option < 1 || $global_option > 3 ]]; then
    echo ""
	echo "==>> #Error! Invalid option. Exiting."
	echo ""
    exit 1
elif [ $global_option == 3 ]; then
	echo ""
    echo "==>> Canceled."
	echo ""
    exit 0
fi

# =========================================================
# STEP 3: VÒNG LẶP THỰC THI TỰ ĐỘNG CHO TẤT CẢ CSDL ĐÃ CHỌN
# =========================================================
echo ""
echo " >>> The environment will be processed: $selected_files"
echo ""

if [[ "$os" == 'Linux' ]]; then
	grep='grep'
	awk='awk'
	java_check="version"
else
	grep='ggrep'
	awk='nawk'
	java_check="version"
fi

time=$(date +'%d_%m_%Y')
SCRIPT=$0
BASE_DIR=$(cd $(dirname "$SCRIPT") && pwd)

for env_file in $selected_files; do
    echo "=================================================="
    echo " >>> LOADING ENVIRONMENT: $env_file"
    echo "=================================================="
    
    # Load biến môi trường
    . "$ENV_DIR/$env_file"
    
	echo ""
    echo "Current ORACLE_SID  : $ORACLE_SID"
    echo "Current ORACLE_HOME : $ORACLE_HOME"
    export PATH=$ORACLE_HOME/bin:$PATH

    # Check Grid home
    grid_file=/etc/init.d/init.ohasd
    if [[ -f "$grid_file" ]]; then
        grid=$($awk -F = '$1 ~ /^ORA_CRS_HOME$/ {print $2}' /etc/init.d/init.ohasd)
        export PATH=$PATH:$grid/bin
    else
		echo ""
        echo "None Grid Environment."
        grid='N/A'
    fi

    # Check connection
    if echo "exit;" | sqlplus / as sysdba 2>&1 | grep -q "Connected to:"; then
        echo ""
		echo "==>> Connect Database OK"
    else
		echo ""
        echo "==>> Connect Database FAIL for $ORACLE_SID. Skipping..."
        continue
    fi

    # Check database is CDB or Non-CDB
    is_cdb=$(
        sqlplus -s / as sysdba <<EOF
set head off feed off
select cdb from $database;
exit
EOF
    )
    is_cdb=$(echo $is_cdb | tr -d '[:space:]')

    # Get db_name & instance_name
    dbname=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select name from $database;
exit
EOF
    )
    dbname=$(echo $dbname | tr -d '[:space:]')

    insname=$(sqlplus -s / as sysdba <<EOF
set head off feed off
show parameter instance_name;
exit
EOF
    )
    insname=$(echo $insname | awk '{print $3}')

    # Trace Log path (Alert log)
    spwd=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select value from $diag where name='Diag Trace';
exit
EOF
    )

    # =========================================================
    # XỬ LÝ TẠO THƯ MỤC VÀ LẤY DANH SÁCH PDB (NẾU LÀ CDB)
    # =========================================================
    if [[ "$is_cdb" == "YES" ]]; then
		echo ""
        echo "==>> Database is CDB. Finding PDBs..."
        
        # Tạo thư mục cho CDB gốc
        cdb_dir="${BASE_DIR}/${insname}_CDB"
		rm -rf "$cdb_dir"
        mkdir -p "$cdb_dir"

        # Lấy danh sách các PDB (Bỏ qua PDB$SEED)
        pdbs=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select name from v\$pdbs where name != 'PDB\$SEED';
exit
EOF
        )
        
        # Đưa các PDB vào danh sách lặp (Cộng thêm CDB$ROOT để check cả CDB)
        target_containers="CDB\$ROOT $pdbs"
    else
		echo ""
        echo "==>> Database is Non-CDB."
        cdb_dir="${BASE_DIR}/${insname}"
		rm -rf "$cdb_dir"
        mkdir -p "$cdb_dir"
        target_containers="NON_CDB"
    fi

    # =========================================================
    # VÒNG LẶP CHECK CHO TỪNG CONTAINER (CDB$ROOT / PDBs)
    # =========================================================
    for con in $target_containers; do

        if [[ "$con" == "NON_CDB" ]]; then
            work_dir="$cdb_dir"
            con_clause=""
			echo ""
            echo "Processing Non-CDB: $insname"
        elif [[ "$con" == "CDB\$ROOT" ]]; then
            work_dir="${cdb_dir}/CDB_ROOT"
            mkdir -p "$work_dir"
            con_clause="ALTER SESSION SET CONTAINER = CDB\$ROOT;"
			echo ""
            echo "Processing Container: CDB\$ROOT"
        else
            work_dir="${cdb_dir}/${con}"
            mkdir -p "$work_dir"
            con_clause="ALTER SESSION SET CONTAINER = ${con};"
			echo ""
            echo "Processing PDB: ${con}"
        fi

        cd "$work_dir"

        # =========================================================
        # THỰC THI CHỨC NĂNG CỦA OPTION 1
        # =========================================================
        if [ $global_option == 1 ]; then
            
            # 1. Alert Log
                cp $spwd/alert_$ORACLE_SID.log . 2>/dev/null
				echo ""
                echo "*** Copy Alert_log done. ***"

            # 2. HealthCheck (Chuyển Container trước khi chạy SQL)
            sqlplus / as sysdba <<EOF
$con_clause
@$BASE_DIR/HealthCheck.sql
exit
EOF
            echo ""
			echo "*** Get HealthCheck done for $con. ****"

            # 3. Database Information
            sqlplus / as sysdba <<EOF
$con_clause
@$BASE_DIR/database_information.sql
exit
EOF
            echo ""
			echo "*** Get Database Information done for $con. ***"
			echo ""

            # 4. Chạy OS Commands & Báo cáo HTML
            file_name='database_information.html'
            unamestr=$(uname)
            [[ "$unamestr" == 'AIX' ]] && disk_command='df -g' || disk_command='df -h'

            # Disk Usage
            echo "<p>+ DISK_USAGE</p>" >>$file_name
            $disk_command -P | $grep -v ^none | ( read header; echo "$header"; sort -rn -k 5 ) | $awk 'BEGIN{print("<table WIDTH='90%' BORDER='1'><tr><th>FILESYSTEM</th><th>SIZE</th><th>USED</th><th>AVAIL</th><th>USE%</th><th>MOUNTED_ON</th></tr>")} {if ($2!="0K" && $2!="Size") print("<tr><td>",$1,"</td><td>",$2,"</td><td>",$3,"</td><td>",$4,"</td><td>",$5,"</td><td>",$6,$7,"</td></tr>")} END{print("</table><p><p>")}' >>$file_name

            # Check Listener
            echo "<p>+ CHECK_LISTENER</p>" >>$file_name
            lsnrctl stat | awk 'BEGIN{print("<p><table WIDTH='90%' BORDER='1'><tr><th>LISTENER_STATUS</th></tr><tr><td>")} {if ($0!=NULL) print($0,"<br>")} END{print("</tr></td></table><p><p>")}' >>$file_name

            # Check Patches
            echo "<p>+ CHECK_PATCHES</p>" >>$file_name
            $ORACLE_HOME/OPatch/opatch lsinventory | $grep -B 2 "Patch description" | grep -v "Unique" | $awk -v hs=$host -v oraclehome=$ORACLE_HOME 'BEGIN{print("<p><table WIDTH='90%' BORDER='1'><tr><th>SERVER</th><th>ORACLE_HOME</th><th>PATCH INFORMATION</th></tr><tr><td>",hs,"</td><td>",oraclehome,"</td><td>")} {if ($0!=NULL) print($0,"<br>")} END{print("</tr></td></table><p><p>")}' >>$file_name

            # Backup Policy
            echo "<p>+ BACKUP_POLICY</p>" >>$file_name
            echo "<table WIDTH='90%' BORDER='1'><tr><th>RMAN_RETENTION</th></tr><tr><td>" >>$file_name
            rman target / <<EOF | grep CONFIGURE >>$file_name
show retention policy;
EOF
            echo "</tr></td><tr><td>NULL</td></tr></table>" >>$file_name

            # Grid/Cluster Check
            if [ "$grid" == "N/A" ]; then
                echo "<p>+ RESOURCE_CRS</p><table WIDTH='90%' BORDER='1'><tr><th>NAME</th><th>TARGET</th><th>STATE</th><th>TARGET_SERVER</th><th>STATE_DETAILS</th></tr><tr><td>NULL</td><td>NULL</td><td>NULL</td><td>NULL</td><td>NULL</td></tr></table><p>+ CHECK_CLUSTER</p><table WIDTH='90%' BORDER='1'><tr><th>HOST_NAME</th><th>CLUSTER_SERVICE</th></tr><tr><td>NULL</td><td>NULL</td></tr></table>" >>$file_name
            else
                echo "<p>+ RESOURCE_CRS<p>" >>$file_name
                crsctl status resource -v | egrep -e "NAME|TARGET|STATE|LAST_SERVER|STATE_DETAILS" | /bin/gawk 'BEGIN {FS="=";} {if ($1=="NAME") resname=$2; else if ($1=="TARGET") restrg=$2; else if ($1=="STATE") resst=$2; else if ($1=="LAST_SERVER") resser=$2; else if ($1=="STATE_DETAILS") {resdet=$2; if(length($3)!=0) resdet=resdet"="$3; idxx1=index(resst, " "); tat=substr(resst, 0, idxx1); if (tat=="") tat="OFFLINE"; printf "%-35s %-20s %-25s %-20s %-10s\n", resname, restrg, tat, resser, resdet}}' | $awk 'BEGIN{print("<table WIDTH='90%' BORDER='1'><tr><th>NAME</th><th>TARGET</th><th>STATE</th><th>LAST_SERVER</th><th>STATE_DETAILS</th></tr>")} {if ($4!=NULL) print("<tr><td>",$1,"</td><td>",$2,"</td><td>",$3,"</td><td>",$4,"</td><td>",$5,$6,$7,$8,"</td></tr>")} END{print("</table>")}' >>$file_name
            fi

            # 5. Export AWR Report
			echo "==>> Processing AWR Report for container: $con..."

            # Bước 1: Lấy Snap ID cao nhất theo DB Time ngay tại context hiện tại ($con)
            end_snap_id=$(sqlplus -s / as sysdba <<EOF
set head off feed off
SELECT snap_id
FROM (
    SELECT snap.snap_id, 
           (stat.sum_val - LAG(stat.sum_val) OVER (ORDER BY snap.instance_number, snap.snap_id)) AS delta
    FROM 
        (SELECT snap_id, instance_number, begin_interval_time 
         FROM dba_hist_snapshot 
         WHERE dbid = (SELECT dbid FROM $database)
        ) snap,
        (SELECT instance_number FROM $instance) inst,
        (SELECT instance_number, snap_id, SUM(value) sum_val
         FROM dba_hist_service_stat
         WHERE stat_name = 'DB time'
           AND dbid = (SELECT dbid FROM $database)
         GROUP BY instance_number, snap_id
        ) stat
    WHERE snap.instance_number = stat.instance_number
      AND snap.instance_number = inst.instance_number
      AND snap.snap_id = stat.snap_id
      AND snap.begin_interval_time > sysdate - 7
    ORDER BY delta DESC NULLS LAST
)
WHERE ROWNUM <= 1;
exit
EOF
            )
            end_snap_id=$(echo $end_snap_id | tr -d '[:space:]')

            if [ -n "$end_snap_id" ] && [ "$end_snap_id" -gt 0 ] 2>/dev/null; then
                begin_snap_id=$((end_snap_id - 1))
				clean_con=$(echo "$con" | tr -d '$#*')
                TEMPFILE="/tmp/tmpawr_${clean_con}.sql"

                # Đặt tên file AWR phân biệt rõ CDBROOT hay PDB
				if [[ "$con" == "NON_CDB" ]]; then
                    awr_report_name="awrrpt_${time}_${insname}.html"
                elif [[ "$con" == "CDB\$ROOT" ]]; then
                    awr_report_name="awrrpt_${time}_${insname}_CDBROOT.html"
                else
                    awr_report_name="awrrpt_${time}_PDB_${con}.html"
                fi

                # Bước 2: Tạo file script chạy AWR động
                sqlplus -s / as sysdba <<EOF >/dev/null
$con_clause
set echo off head off feed off
spool ${TEMPFILE}
select 'define begin_snap = ${begin_snap_id}' from dual;
select 'define end_snap = ${end_snap_id}' from dual;
select 'define report_type = ''html''' from dual;
select 'define inst_name = ' || INSTANCE_NAME from v\$instance;
select 'define db_name = ' || name from v\$database;
select 'define dbid = ' || dbid from v\$database;
select 'define inst_num = ' || INSTANCE_NUMBER from v\$instance;
select 'define num_days = 7' from dual;
select 'define report_name = ${awr_report_name}' from dual;
select '@$ORACLE_HOME/rdbms/admin/awrrpt.sql' from dual;
spool off
exit
EOF

                # Bước 3: Thực thi tạo báo cáo AWR (Đã bao gồm ALTER SESSION SET CONTAINER)
                sqlplus -s / as sysdba <<EOF >/dev/null
$con_clause
@$TEMPFILE
exit
EOF
                [ -f "$TEMPFILE" ] && rm -f $TEMPFILE
				echo ""
                echo "*** Get Awrrpt done for $con. ***"
            else
				echo ""
                echo "*** WARNING: No Snapshot found for AWR in $con. ***"
            fi

            # 6. Tổng hợp bảng thông tin Report Details
            rp_ha=$(sqlplus -s / as sysdba <<EOF
set head off feed off
SELECT VALUE FROM $parameter WHERE NAME = 'cluster_database';
exit
EOF
            )
            [[ "$(echo $rp_ha | tr -d '[:space:]')" == 'TRUE' ]] && rp_ha_last='RAC' || rp_ha_last='Stand Alone'

            os_last="$(uname -o 2>/dev/null || uname -s) $(uname -m)"

            if [[ "$os" == 'Linux' ]]; then
                cpu=$(lscpu | grep -E '^CPU\(s\):' | tr -dc '0-9')
                ram=$(cat /proc/meminfo | grep MemTotal | tr -dc '0-9')
                ram_last=$(expr "$ram" / 1048576)
            else
                cpu=$(psrinfo -p)
                ram=$(prtconf | grep Mem | ggrep -E -o '[0-9]+')
                ram_last=$(expr "$ram" / 1024)
            fi
            hw_last="CPU: $cpu cores, RAM: $ram_last GB"

            dtf=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select name from $datafile where name like '+%' and rownum=1;
exit
EOF
            )
            [[ $dtf == *[+]* ]] && dtf_last="ASM" || dtf_last="File System"

            arc=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select log_mode from $database;
exit
EOF
            )
            [[ "$(echo $arc | tr -d '[:space:]')" == 'ARCHIVELOG' ]] && arc_last='Yes' || arc_last='No'

            fls=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select FLASHBACK_ON from $database;
exit
EOF
            )
            [[ "$(echo $fls | tr -d '[:space:]')" == 'YES' ]] && fls_last='Yes' || fls_last='No'

            ver_last=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select version from $instance;
exit
EOF
            )

            pat_last=$($ORACLE_HOME/OPatch/opatch lspatches | $grep "Database" | $awk -v FS=';' '{print $2}')
            
            size=$(sqlplus -s / as sysdba <<EOF
set feedback off head off feed off pages 0
$con_clause
select round(sum(bytes)/1024/1024/1024,2) from $datafile;
exit
EOF
            )
            size=$(echo $size | tr -d '[:space:]')
            size_last="$size GB"

            bkp_last=$(sqlplus -s / as sysdba <<EOF
set head off feed off
select status from $backupjob where rownum=1;
exit
EOF
            )

            echo "<p>+ REPORT DETAILS FOR CONTAINER: $con</p>" >>$file_name
            echo "<table WIDTH='90%' BORDER='1'><tr><th>ITEMS</th><th>INFORMATION</th></tr>" >>$file_name
            echo "<tr><td>Container Name</td><td>$con</td></tr>" >>$file_name
            echo "<tr><td>DB Name</td><td>$dbname</td></tr>" >>$file_name
            echo "<tr><td>HA/Stand Alone</td><td>$rp_ha_last</td></tr>" >>$file_name
            echo "<tr><td>OS Version</td><td>$os_last</td></tr>" >>$file_name
            echo "<tr><td>Hardware (CPU,RAM)</td><td>$hw_last</td></tr>" >>$file_name
            echo "<tr><td>File System/raw devices</td><td>$dtf_last</td></tr>" >>$file_name
            echo "<tr><td>Archiving Enabled</td><td>$arc_last</td></tr>" >>$file_name
            echo "<tr><td>Flashback Enabled</td><td>$fls_last</td></tr>" >>$file_name
            echo "<tr><td>Version</td><td>$ver_last</td></tr>" >>$file_name
            echo "<tr><td>Patch</td><td>$pat_last</td></tr>" >>$file_name
            echo "<tr><td>DB Size</td><td>$size_last</td></tr>" >>$file_name
            echo "<tr><td>Backup status</td><td>$bkp_last</td></tr></table>" >>$file_name

        elif [ $global_option == 2 ]; then
            # OSWatcher chỉ chạy 1 lần ở mức OS
            if [[ "$con" == "NON_CDB" || "$con" == "CDB\$ROOT" ]]; then
				echo ""
                echo "Setup OSWatcher for $ORACLE_SID..."
                if java -version 2>&1 >/dev/null | $grep "$java_check"; then
                    tar -xf $BASE_DIR/oswbb840.tar -C $BASE_DIR/. 2>/dev/null
                    mkdir -p $BASE_DIR/oswbb_log_MPS_$host
                    cd $BASE_DIR/oswbb
                    nohup ./startOSWbb.sh 300 120 None $BASE_DIR/oswbb_log_MPS_$host/ >nohup.out 2>&1 &
                fi
            fi
        fi

    done # Kết thúc vòng lặp lặp các PDB/CDB

    echo ""
    echo " >>> Done for $ORACLE_SID!"
    echo "=================================================="
    echo ""
    cd "$BASE_DIR"

done # Kết thúc vòng lặp các Instance

echo "==>> ALL PROCESS COMPLETED!"
echo ""