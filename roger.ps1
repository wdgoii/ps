# Script PowerShell para otimizar o sistema e corrigir lentidão

# Autoelevação de privilégios
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Reexecutando como administrador..."
    $scriptPath = $MyInvocation.MyCommand.Definition
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}

Write-Host "Iniciando otimização do sistema..." -ForegroundColor Cyan
$totalRemovidos = 0

function Limpar-Caminho($caminho) {
    if (Test-Path $caminho) {
        $arquivos = Get-ChildItem -Path $caminho -Recurse -Force -ErrorAction SilentlyContinue
        $totalRemovidos += $arquivos.Count
        Remove-Item -Path $caminho\* -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Limpar arquivos temporários
Write-Host "Limpando arquivos temporários..."
Limpar-Caminho "$env:TEMP"
Limpar-Caminho "C:\Windows\Temp"

# Limpar cache do Windows Update
Write-Host "Limpando cache do Windows Update..."
Stop-Service -Name wuauserv -Force
Limpar-Caminho "C:\Windows\SoftwareDistribution\Download"
Start-Service -Name wuauserv

# Remover atualizações obsoletas
Write-Host "Removendo atualizações obsoletas..."
Start-Process -FilePath "cmd.exe" -ArgumentList "/c Dism /Online /Cleanup-Image /StartComponentCleanup" -Wait

# Limpar logs e arquivos de erro
Write-Host "Limpando logs e arquivos de erro..."
Limpar-Caminho "C:\Windows\Logs"
Limpar-Caminho "C:\Windows\System32\LogFiles"

# Limpar arquivos de pré-busca (Prefetch)
Write-Host "Limpando arquivos de pré-busca..."
Limpar-Caminho "C:\Windows\Prefetch"

# Limpar cache do Microsoft Edge
Write-Host "Limpando cache do Microsoft Edge..."
Limpar-Caminho "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"

# Limpar cache do Google Chrome
Write-Host "Limpando cache do Google Chrome..."
Limpar-Caminho "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"

# Limpar cache do Mozilla Firefox
Write-Host "Limpando cache do Mozilla Firefox..."
$firefoxPerfis = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
foreach ($perfil in $firefoxPerfis) {
    Limpar-Caminho "$($perfil.FullName)\cache2"
}

# Limpar cache do Brave
Write-Host "Limpando cache do Brave..."
Limpar-Caminho "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache"

# Finalizar processos desnecessários
Write-Host "Finalizando processos desnecessários..."
$processos = @("OneDrive", "Teams", "Skype", "YourPhone")
foreach ($proc in $processos) {
    Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

# Verificar e reparar arquivos do sistema
Write-Host "Verificando arquivos do sistema..."
Start-Process -FilePath "cmd.exe" -ArgumentList "/c sfc /scannow" -Wait

# Otimizar disco (somente se não for SSD)
Write-Host "Otimização de disco..."
Optimize-Volume -DriveLetter C -Verbose

# Desabilitar programas de inicialização desnecessários
Write-Host "Desabilitando programas de inicialização..."
Get-CimInstance -ClassName Win32_StartupCommand | ForEach-Object {
    Write-Host "Detectado: $($_.Name)"
    # Para desativar, use ferramentas como Autoruns ou o Gerenciador de Tarefas
}

Write-Host "`nOtimização concluída!" -ForegroundColor Green
Write-Host "Total de arquivos removidos: $totalRemovidos" -ForegroundColor Yellow

# Pausa no final para manter a janela aberta
Write-Host "`nPressione qualquer tecla para sair..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
