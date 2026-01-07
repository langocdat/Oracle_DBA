@echo off
set ORACLE_HOME=C:\app\oracle\product\19c\dbhome_1
set ORACLE_SID=orcl
set PATH=%ORACLE_HOME%\bin;%PATH%

set NLS_DATE_FORMAT=YYYY-MM-DD HH24:MI:SS

for /f %%i in ('powershell -command "Get-Date -Format yyyyMMdd"') do set TODAYDATE=%%i

set BASEDIR=C:\Backup\%TODAYDATE%
set BKDIR=%BASEDIR%\BK_DB_LV1_%TODAYDATE%

if not exist "%BKDIR%" mkdir "%BKDIR%"

set LOGFILE=%BKDIR%\LogBK_DB_LV1_%TODAYDATE%.log
set RMANSCRIPT=%BKDIR%\BK_DB_LV1_%TODAYDATE%.rman

echo start >> "%LOGFILE%"
echo %DATE% %TIME% >> "%LOGFILE%"

(
echo run {
echo   crosscheck backup;
echo   crosscheck archivelog all;
echo   delete noprompt expired backup;
echo   delete noprompt expired archivelog all;
echo   delete noprompt obsolete;
echo.
echo   allocate channel d1 device type disk;
echo   allocate channel d2 device type disk;
echo   allocate channel d3 device type disk;
echo   allocate channel d4 device type disk;
echo.
echo   backup current controlfile
echo     format '%BKDIR%\controlfile_LV1_%%d_%%T_%%U.bkp'
echo     tag='CTL_LV1_%TODAYDATE%';
echo.
echo   backup spfile
echo     format '%BKDIR%\spfile_LV1_%%d_%%T_%%U.bkp'
echo     tag='SPFILE_LV1_%TODAYDATE%';
echo.
echo   backup as compressed backupset
echo     incremental level 1 cumulative database
echo     format '%BKDIR%\datafile_LV1_%%d_%%T_%%U.bkp'
echo     tag='DB_LV1_%TODAYDATE%';
echo.
echo   backup as compressed backupset
echo     archivelog all
echo     format '%BKDIR%\arch_LV1_%%d_%%T_%%U.bkp'
echo     tag='ARC_LV1_%TODAYDATE%';
echo.
echo   release channel d1;
echo   release channel d2;
echo   release channel d3;
echo   release channel d4;
echo }
) > "%RMANSCRIPT%"

rman target / cmdfile="%RMANSCRIPT%" log="%LOGFILE%"

echo Ending Backup >> "%LOGFILE%"
echo %DATE% %TIME% >> "%LOGFILE%"

