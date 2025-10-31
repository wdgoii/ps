# Configurações
$PastaOrigem = "C:\Caminho\Para\Sua\PastaGigante"
$PastaDestinoGdrive = "D:\GoogleDrive\MeuDriveDestino\PastaCopia"  # Ajuste para o caminho LOCAL do seu Google Drive Desktop
$LogFile = "C:\Logs\Copia_Gdrive_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$MaxRetries = 5
$RetryDelaySeconds = 10 # Tempo de espera entre as tentativas (em segundos)

# Lista para armazenar arquivos com erro
$ArquivosComErro = @()

# Cria o diretório de logs se não existir
$LogDir = Split-Path -Path $LogFile -Parent
if (-not (Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory | Out-Null
}

Write-Host "Iniciando cópia incremental de '$PastaOrigem' para '$PastaDestinoGdrive'..."
Write-Host "Log será salvo em: $LogFile"
Write-Host "Tentativas por arquivo: $MaxRetries"
Write-Host "-----------------------------------------------------"

# O Robocopy lida com a cópia incremental (só copia o que mudou) por padrão.
# /E: Copia subdiretórios, incluindo vazios.
# /Z: Modo de reinício (útil para cópias grandes).
# /COPYALL: Copia TODAS as informações de arquivos (Dados, Atributos, Timestamps, Segurança, Informações do Proprietário).
# /R:$MaxRetries: Número de repetições em caso de falha (o seu requisito de 5 vezes).
# /W:$RetryDelaySeconds: Tempo de espera entre as repetições (o seu requisito de 5 segundos de espera).
# /NP: Não mostra o percentual de progresso (para um log mais limpo, opcional).
# /LOG+:$LogFile: Adiciona a saída ao arquivo de log.
# /TEE: Mostra a saída no console E no arquivo de log.
# /MIR: Espelha o diretório (ATENÇÃO: ISSO EXCLUI ARQUIVOS NO DESTINO QUE NÃO ESTÃO NA ORIGEM). Se você não quer excluir, use /E e considere usar /XC (exclui arquivos idênticos).

# OPÇÃO MAIS SEGURA/INCREMENTAL (Não exclui nada no destino): /E
$RobocopyCommand = "robocopy `"$PastaOrigem`" `"$PastaDestinoGdrive`" /E /Z /COPYALL /R:$MaxRetries /W:$RetryDelaySeconds /TEE /LOG+:`"$LogFile`""

# Executa o Robocopy
Invoke-Expression $RobocopyCommand

# --- Análise do Log para identificar erros de cópia (Robocopy retorna códigos de saída) ---
# O Robocopy retorna códigos de 0 a 7 para sucesso/aviso e 8+ para erro grave.
# Para o nosso propósito (verificar arquivos que deram erro), o melhor é analisar o log.

Write-Host "Analisando o arquivo de log para erros de cópia de arquivos individuais..."

# Padrões de erro comuns do Robocopy (para arquivos) no log:
# "ERROR" ou a linha que descreve o arquivo com o resultado
# Um resultado "Falhou" (FAILED) ou uma linha que indica que o arquivo não pôde ser copiado após as tentativas.
# Devido à complexidade de analisar *todas* as saídas de erro de arquivo do Robocopy puramente no PowerShell sem usar a API,
# a abordagem mais fácil é filtrar as linhas que contêm "ERROR" ou que mostram o arquivo tentando e falhando.

# Filtra as linhas no log que sugerem falha (pode ser ajustado)
# Vamos filtrar linhas que mencionam "Failed" ou que são erros diretos no log
$ErrorLines = Select-String -Path $LogFile -Pattern "ERROR|Failed|Não foi possível copiar" -AllMatches

if ($ErrorLines) {
    Write-Host "ERROS ENCONTRADOS! Verifique o relatório abaixo."
    
    # Tenta extrair o nome do arquivo após as tentativas.
    # Esta é uma simplificação e pode precisar de ajuste dependendo da versão exata do log.
    # Tentamos encontrar a última linha do arquivo que menciona o arquivo específico após a tentativa.
    
    # Busca por linhas que parecem ser a descrição do arquivo com resultado
    $FailedFilesRaw = Select-String -Path $LogFile -Pattern "\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+" -AllMatches | 
                      Where-Object { $_.Line -match ':\s+\d+\s+\d+\s+\d+\s+\d+\s+NO MORE RETRIES' -or $_.Line -match ':\s+\d+\s+\d+\s+\d+\s+\d+\s+FAILED' }
                      
    if ($FailedFilesRaw) {
        foreach ($match in $FailedFilesRaw) {
            # Extrai o nome do arquivo da linha de log. Isso é altamente dependente do formato do log do Robocopy.
            # Uma abordagem mais segura é listar arquivos que não existem no destino ou que têm timestamp diferente.
            # Para este requisito, vamos apenas listar o conteúdo do log de erro encontrado.
            $ArquivosComErro += $match.Line.Trim()
        }
    } else {
        # Se a extração for muito complexa, apenas adiciona as linhas de erro geral.
        $ArquivosComErro += "ERRO GERAL DE CÓPIA OU FALHA DE REINTENTAÇÃO. Consulte o log completo: $LogFile"
    }

} else {
    Write-Host "Cópia concluída. Nenhuma falha de arquivo detectada (ou o Robocopy não retornou o erro esperado no log)."
}

# --- Relatório Final ---
Write-Host "`n====================================================="
Write-Host "RELATÓRIO FINAL DA CÓPIA"
Write-Host "====================================================="

if ($ArquivosComErro.Count -gt 0) {
    Write-Host "Arquivos que falharam a cópia após $MaxRetries tentativas (Detalhes do Log):" -ForegroundColor Red
    $ArquivosComErro | ForEach-Object { Write-Host "  - $_" }
} else {
    Write-Host "SUCESSO: Todos os arquivos foram copiados ou já estavam sincronizados." -ForegroundColor Green
}

Write-Host "`nConsulte o log completo para detalhes: $LogFile"
Write-Host "-----------------------------------------------------"