Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Script PowerShell para coletar eventos de erro e críticos do dia atual para investigar tela azul.

# Define o dia de hoje para filtrar os eventos
$hoje = Get-Date -Format "yyyy-MM-dd"

# Consulta os logs de eventos de Sistema e Aplicação para eventos de Erro e Crítico no dia de hoje
Write-Host "Procurando eventos de Erro e Crítico nos logs de Sistema e Aplicação para o dia: $($hoje)"
Get-WinEvent -FilterHashtable @{
    LogName = @("System", "Application")
    Level = @("1", "2") # 1: Critical, 2: Error
    StartTime = (Get-Date -Date $hoje).Date
    EndTime = (Get-Date -Date $hoje).Date.AddDays(1)
} | Sort-Object TimeCreated -Descending | Format-Table LogName, TimeCreated, ID, LevelDisplayName, Source, Message -AutoSize

Write-Host ""
Write-Host "Script concluído. Verifique os eventos listados acima para identificar possíveis causas da tela azul."
Write-Host "Procure por eventos com 'LevelDisplayName' 'Error' ou 'Critical' e examine as colunas 'Source' e 'Message' para mais detalhes."
