Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/informacoes.ps1" -OutFile .\informacoes.ps1
# copiar pasta drive mpf => drive local
# descompactar