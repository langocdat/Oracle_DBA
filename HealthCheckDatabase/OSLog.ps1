$LogPath = "C:\OSLogs"
$SetName = "OSLog"
$Hostname = $env:COMPUTERNAME 
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = "$LogPath\OSLog_${Hostname}_${Timestamp}.csv"

if (!(Test-Path $LogPath)) { 
    New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
}

$LogmanExe = "C:\Windows\System32\logman.exe"

& $LogmanExe stop "$SetName" >$null 2>&1
& $LogmanExe delete "$SetName" >$null 2>&1

& $LogmanExe create counter "$SetName" `
    -c "\Processor(_Total)\% Idle Time" `
       "\Processor(_Total)\% User Time" `
       "\Processor(_Total)\% Privileged Time" `
       "\Memory\Available KBytes" `
       "\Paging File(_Total)\% Usage" `
       "\PhysicalDisk(*)\% Disk Time" `
       "\PhysicalDisk(*)\Avg. Disk Queue Length" `
       "\PhysicalDisk(*)\Disk Transfers/sec" `
    -si 00:00:10 `
    -f csv `
    -o "$LogFile" `
    -max 0

& $LogmanExe start "$SetName"

Write-Host "---"
Write-Host "OSLog started successfully!" -ForegroundColor Green
Write-Host "File log: $LogFile" -ForegroundColor Cyan
Write-Host "Check status: logman query $SetName" -ForegroundColor Yellow
Write-Host "To stop: logman stop $SetName" -ForegroundColor Red
Write-Host "---"