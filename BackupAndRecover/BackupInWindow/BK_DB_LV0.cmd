@echo off
set ORACLE_HOME=C:\app\oracle\product\19c\dbhome_1
set ORACLE_SID=orcl
set PATH=%ORACLE_HOME%\bin;%PATH%

set NLS_DATE_FORMAT=YYYY-MM-DD HH24:MI:SS

for /f %%i in ('powershell -command "Get-Date -Format yyyyMMdd"') do set TODAYDATE=%%i

set BASEDIR=F:\Backup\LV0_%TODAYDATE%
set BKDIR=%BASEDIR%\BACKUPFILES
set LOGDIR=%BASEDIR%\LOGS

if not exist "%BKDIR%" mkdir "%BKDIR%"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

set LOGFILE=%LOGDIR%\LogBK_DB_LV0_%TODAYDATE%.log
set RMANSCRIPT=%LOGDIR%\BK_DB_LV0_%TODAYDATE%.rman

echo start >> "%LOGFILE%"
echo %DATE% %TIME% >> "%LOGFILE%"

(
echo run {
echo    crosscheck backup;
echo    crosscheck archivelog all;
echo    delete noprompt expired backup;
echo    delete noprompt expired archivelog all;
echo    delete noprompt obsolete;
echo.
echo    allocate channel d1 device type disk;
echo    allocate channel d2 device type disk;
echo    allocate channel d3 device type disk;
echo    allocate channel d4 device type disk;
echo    allocate channel d5 device type disk;
echo    allocate channel d6 device type disk;
echo    allocate channel d7 device type disk;
echo    allocate channel d8 device type disk;
echo.
echo    backup as compressed backupset
echo      incremental level 0 database
echo      format '%BKDIR%\datafile_LV0_%%d_%%T_%%U.bkp'
echo      tag='DB_LV0_%TODAYDATE%';
echo.
echo    backup as compressed backupset
echo      archivelog all
echo      format '%BKDIR%\arch_LV0_%%d_%%T_%%U.bkp'
echo      tag='ARC_LV0_%TODAYDATE%';
echo.
echo    backup spfile
echo      format '%BKDIR%\spfile_LV0_%%d_%%T_%%U.bkp'
echo      tag='SPFILE_LV0_%TODAYDATE%';
echo.
echo    backup current controlfile
echo      format '%BKDIR%\controlfile_LV0_%%d_%%T_%%U.bkp'
echo      tag='CTL_LV0_%TODAYDATE%';
echo.
echo    crosscheck archivelog all;
echo    delete noprompt archivelog until time 'SYSDATE - 15';
echo.
echo    release channel d1;
echo    release channel d2;
echo    release channel d3;
echo    release channel d4;
echo    release channel d5;
echo    release channel d6;
echo    release channel d7;
echo    release channel d8;
echo }
) > "%RMANSCRIPT%"

rman target / cmdfile="%RMANSCRIPT%" log="%LOGFILE%"

echo Ending Backup >> "%LOGFILE%"
echo %DATE% %TIME% >> "%LOGFILE%"