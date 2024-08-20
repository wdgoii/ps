Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Write-Output "sjrp 12ms "
Test-NetConnection portal-preprod.mpf.mp.br -InformationLevel Detailed
Write-Output "sjrp W 11 Pro => Windows 10 Pro 22621.1 220506-1250"
Write-Output "sjrp W 10 Pro => Windows 10 Pro 19041.1.amd64fre.vb_release.191206-1406"
(Get-CimInstance Win32_OperatingSystem).Caption							
get-computerinfo|select WindowsBuildLabEx							
Clear-DnsClientCache

# firefox reinstalado . politicas de grupo removidas ( HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox )
Remove-Item -Path HKLM:\SOFTWARE\Policies\Mozilla\Firefox -Recurse

Write-Output "minha conexao sjrp 39,3mbps / 52,7 mbps"
Start-Process chrome 'https://www.minhaconexao.com.br --incognito'
taskmgr.exe
Get-Process | Where-Object { $_.CPU -gt 70 -and $_.WS -gt 50MB }  | Sort-Object cpu -Descending | select id,path,Description,StartTime,processname | Format-Table

# dism /online /cleanup-image /scanhealth
# dism /online /cleanup-image /restorehealth
# sfc /scannow