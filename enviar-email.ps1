Set-ExecutionPolicy -ExecutionPolicy  Bypass -Scope CurrentUser
# Configurações do Servidor
$IPublico = (Invoke-WebRequest -uri "https://api.ipify.org").Content
$SmtpServer = "smtp.gmail.com" # Ou smtp-mail.outlook.com
$SmtpPort = 587

# Credenciais
$Usuario = "rwinformaticasjrp@gmail.com"
$Senha = "hayj ebiw nicf wkjf" # IMPORTANTE: Use senha de aplicativo, não a senha comum

# Mensagem
$De = "rwinformaticasjrp@gmail.com"
$Para = "wdgoii@gmail.com"
$Assunto = "IP Publico Rogerio"
$Corpo = "IP para acesso RDP é: $IPublico"

# Criando o objeto de e-mail
$Mensagem = New-Object System.Net.Mail.MailMessage($De, $Para, $Assunto, $Corpo)
$SMTPClient = New-Object System.Net.Mail.SmtpClient($SmtpServer, $SmtpPort)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Usuario, $Senha)

# Enviando
try {
    $SMTPClient.Send($Mensagem)
    Write-Host "E-mail enviado com sucesso!" -ForegroundColor Green
} catch {
    Write-Error "Erro ao enviar: $($_.Exception.Message)"
} finally {
    $Mensagem.Dispose()
    $SMTPClient.Dispose()
}