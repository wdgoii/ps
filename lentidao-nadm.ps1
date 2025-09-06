Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Clear-Host

Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\" -Directory | ForEach-Object {
    $cachePath = "$($_.FullName)\cache2\*"
    Remove-Item -Path $cachePath -Recurse -Force -ErrorAction SilentlyContinue
}

Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:1"



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
 Repair-Volume -ObjectId "$($Vols[$($Cntr)].ObjectId)" 2>$null
}

#get-childitem -Path 'C:\Users\wdgoi\AppData\Local\Google\Chrome\User Data' -recurse -file | Where-Object {$_.PSpath -match "cookies"} | remove-item -Force
$Us = get-localUser | where-Object {$_.enabled -eq 'True'}
For ($Cntr = 0 ; $Cntr -lt $Us.Count; $Cntr++) {
    Get-ChildItem -File -Path "C:\Users\$($Us[$($Cntr)].name)\AppData" | Where-Object { ($_.PSpath -match "\\cache\\") -or ($_.PSpath -match "\\temp\\")  } | Remove-Item -force -ErrorAction SilentlyContinue 2>$null
}

#saude hd
Get-CimInstance -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus | Select-Object reason,active,instancename

# Clear-DnsClientCache
# dism /online /cleanup-image /scanhealth
# dism /online /cleanup-image /restorehealth
# sfc /scannow
# repair-Volume -DriveLetter c -Scan -Verbose
# chkdsk /f /r /b