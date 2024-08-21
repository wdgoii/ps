Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Write-Output "sjrp 12ms "
Test-NetConnection portal-preprod.mpf.mp.br -InformationLevel Detailed

Write-Output "sjrp W 11 Pro => Windows 10 Pro 22621.1 220506-1250"
Write-Output "sjrp W 10 Pro => Windows 10 Pro 19041.1.amd64fre.vb_release.191206-1406"
(Get-CimInstance Win32_OperatingSystem).Caption							
get-computerinfo|select WindowsBuildLabEx

##pastas temporarias
get-childitem -Path C:\Windows -recurse -file| Where-Object {$_.PSpath -match "\\Temp\\"} | Remove-Item -force -ErrorAction SilentlyContinue
get-childitem -Path C:\Users\ -recurse -file| Where-Object {$_.PSpath -match "\\Temp\\"} | Remove-Item -force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item -Path HKLM:\SOFTWARE\Policies\Mozilla\Firefox -Recurse

Write-Output "minha conexao sjrp 39,3mbps / 52,7 mbps"
Start-Process chrome 'https://www.minhaconexao.com.br --incognito'
taskmgr.exe
Get-Process | Where-Object { $_.CPU -gt 70 -and $_.WS -gt 50MB }  | Sort-Object cpu -Descending | select id,path,Description,StartTime,processname | Format-Table

$Vols = Get-Volume
"There are $($Vols.Count) volumes to process!"
For ($Cntr = 0 ; $Cntr -lt $Vols.Count; $Cntr++) {
 Repair-Volume -ObjectId "$($Vols[$($Cntr)].ObjectId)"
}

#get-childitem -Path 'C:\Users\wdgoi\AppData\Local\Google\Chrome\User Data' -recurse -file | Where-Object {$_.PSpath -match "cookies"} | remove-item -Force
$Us = get-localUser | where-Object {$_.enabled -eq 'True'}
For ($Cntr = 0 ; $Cntr -lt $Us.Count; $Cntr++) {
    remove-item "C:\Users\$($Us[$($Cntr)].name)\AppData\Local\Google\Chrome\User Data\Default\Cache\*.*" -ErrorAction Continue
}




# Clear-DnsClientCache
# dism /online /cleanup-image /scanhealth
# dism /online /cleanup-image /restorehealth
# sfc /scannow
# repair-Volume -DriveLetter c -Scan -Verbose
# chkdsk /f /r /b