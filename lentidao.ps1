Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#main

#get-childitem -Path C:\Windows -recurse -file -ErrorAction Continue SilentlyContinue | Where-Object {$_.PSpath -match "\\Temp\\"} | Remove-Item -force -ErrorAction SilentlyContinue 2>$null

#limpar pastas temp dentro da pasta users
$userProfiles = Get-CimInstance -ClassName Win32_UserProfile | Where-Object {
    $_.LocalPath -notlike '*\systemprofile*' -and
    $_.LocalPath -notlike '*\serviceprofiles*' -and
    $_.LocalPath -notlike '*\Public'
} | Select-Object -ExpandProperty LocalPath
foreach ($profilePath in $userProfiles) {
    $LocaltempPath = Join-Path -Path $_.LocalPath -ChildPath 'AppData\Local'
    get-childitem -Path $LocaltempPath -recurse -Force | Where-Object {$_.PSpath -match "\\Temp\\"} | Remove-Item -force -ErrorAction SilentlyContinue 2>$null
    get-childitem -Path $LocaltempPath -recurse -Force | Where-Object {$_.PSpath -match "\\cache*\\"} | Remove-Item -force -ErrorAction SilentlyContinue 2>$null
}

Get-ChildItem -Path "C:\Windows\Temp" -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\Windows\Logs" -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\Windows\System32\LogFiles" -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\Windows\Prefetch" -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

Stop-Service -Name wuauserv -Force
Get-ChildItem -Path "C:\Windows\SoftwareDistribution\Download" -Recurse -Force | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Start-Service -Name wuauserv

# Removendo atualizações obsoletas
Start-Process -FilePath "cmd.exe" -ArgumentList "/c Dism /Online /Cleanup-Image /StartComponentCleanup" -Wait

Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item -Path HKLM:\SOFTWARE\Policies\Mozilla\Firefox -Recurse

$Vols = Get-Volume
"There are $($Vols.Count) volumes to process!"
For ($Cntr = 0 ; $Cntr -lt $Vols.Count; $Cntr++) {
 Repair-Volume -ObjectId "$($Vols[$($Cntr)].ObjectId)" 2>$null
}

#get-childitem -Path 'C:\Users\wdgoi\AppData\Local\Google\Chrome\User Data' -recurse -file | Where-Object {$_.PSpath -match "cookies"} | remove-item -Force
$Us = get-localUser | where-Object {$_.enabled -eq 'True'}
For ($Cntr = 0 ; $Cntr -lt $Us.Count; $Cntr++) {
    Get-ChildItem -File -Path "C:\Users\$($Us[$($Cntr)].name)\AppData" | Where-Object { ($_.PSpath -match "\\cache*\\") -or ($_.PSpath -match "\\temp\\")  } | Remove-Item -force -ErrorAction SilentlyContinue 2>$null
}

#saude hd
Get-CimInstance -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus | Select-Object reason,active,instancename

# Clear-DnsClientCache
# dism /online /cleanup-image /scanhealth
# dism /online /cleanup-image /restorehealth
# sfc /scannow
# repair-Volume -DriveLetter c -Scan -Verbose
# chkdsk /f /r /b