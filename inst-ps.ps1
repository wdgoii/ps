Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
<#
#Set-Location C:\Users
$uri = "https://aka.ms/install-powershell.ps1"
Invoke-RestMethod -Uri $uri | Out-File -FilePath C:\users\powershell.ps1
C:\users\powershell.ps1
#>

$latestLTSMsiUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.5.4/PowerShell-7.5.4-win-x64.msi" # Altere a URL para a versão desejada
$outputPath = "C:\windows\Temp\PowerShell.msi"

Invoke-WebRequest -Uri $latestLTSMsiUrl -OutFile $outputPath

# Instala o MSI silenciosamente
Start-Process msiexec.exe -ArgumentList "/i `"$outputPath`" /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1" -Wait -NoNewWindow

Remove-Item $outputPath
Write-Output "Fim inst-ps.ps1"