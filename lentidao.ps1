Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#Write-Output "sjrp 12ms "
#Test-NetConnection portal-preprod.mpf.mp.br -InformationLevel Detailed

(Get-CimInstance Win32_OperatingSystem).Caption							
get-computerinfo|select WindowsBuildLabEx

##pastas temporarias
get-childitem -Path C:\Windows -recurse -file -ErrorAction Continue SilentlyContinue | Where-Object {$_.PSpath -match "\\Temp\\"} | Remove-Item -force -ErrorAction SilentlyContinue 2>$null

Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item -Path HKLM:\SOFTWARE\Policies\Mozilla\Firefox -Recurse

Write-Output "minha conexao sjrp 39,3mbps / 52,7 mbps"
Start-Process chrome 'https://www.minhaconexao.com.br --incognito'
taskmgr.exe

get-process | Sort-Object -Property CPU -Descending | Select-Object id, cpu, name, path -First 30

$Vols = Get-Volume
"There are $($Vols.Count) volumes to process!"
For ($Cntr = 0 ; $Cntr -lt $Vols.Count; $Cntr++) {
 Repair-Volume -ObjectId "$($Vols[$($Cntr)].ObjectId)"
}

#get-childitem -Path 'C:\Users\wdgoi\AppData\Local\Google\Chrome\User Data' -recurse -file | Where-Object {$_.PSpath -match "cookies"} | remove-item -Force
$Us = get-localUser | where-Object {$_.enabled -eq 'True'}
For ($Cntr = 0 ; $Cntr -lt $Us.Count; $Cntr++) {
    Get-ChildItem -File -Path "C:\Users\$($Us[$($Cntr)].name)\AppData" | Where-Object { ($_.PSpath -match "\\cache\\") -or ($_.PSpath -match "\\temp\\")  } | Remove-Item -force -ErrorAction SilentlyContinue
}

#saude hd
Get-CimInstance -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus | Select-Object reason,active,instancename

# Clear-DnsClientCache
# dism /online /cleanup-image /scanhealth
# dism /online /cleanup-image /restorehealth
# sfc /scannow
# repair-Volume -DriveLetter c -Scan -Verbose
# chkdsk /f /r /b