Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Script PowerShell para coletar eventos de erro e críticos do dia atual para investigar tela azul.

Write-Host ""
Write-Host "Script concluído. Verifique os eventos listados acima para identificar possíveis causas da tela azul."
Write-Host "Procure por eventos com 'LevelDisplayName' 'Error' ou 'Critical' e examine as colunas 'Source' e 'Message' para mais detalhes."

Get-WinEvent -FilterHashtable @{
    LogName = "System", "Application"
    Level = 1, 2 # 1: Critical, 2: Error
    StartTime = [datetime]::Today
    EndTime = ([datetime]::Today).Date.AddDays(300)
    } | Sort-Object TimeCreated -Descending | Format-Table LogName, TimeCreated, ID, LevelDisplayName, Source, Message -Wrap